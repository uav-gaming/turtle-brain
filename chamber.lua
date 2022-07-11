-- Clear out a chamber
-- Borrowed from https://pastebin.com/PRmpn1rj

local FUEL_SLOT = 1
local FUEL_ENDERCHEST = 0
local STORAGE_ENDERCHEST = 0
 
--should the turtle dig up
local shouldDigUp = true
 
-- @return true if any slot is empty
function slotsEmpty()
    for i=1, 16 do
        if turtle.getItemCount(i) < 1 then
            return true 
        end
    end
    return false
end
 
function storeStuff()
    if STORAGE_ENDERCHEST >= 1 and STORAGE_ENDERCHEST <= 16 then
        turtle.dig()
        turtle.select(STORAGE_ENDERCHEST)
        turtle.place()
        for i = 1, 16 do
            turtle.select(i)
            if i ~= FUEL_SLOT and i ~= FUEL_ENDERCHEST  and i ~= STORAGE_ENDERCHEST then
                turtle.drop()
            end
        end  
        turtle.select(STORAGE_ENDERCHEST)
        turtle.drop()
        turtle.dig()
        turtle.select(1)
    end
end     
 
function getFuelFromChest()
    if FUEL_ENDERCHEST >= 1 and FUEL_ENDERCHEST <= 16 then
        turtle.dig()
        turtle.select(FUEL_ENDERCHEST)
        turtle.place()
        turtle.select(FUEL_SLOT)
        turtle.drop()
        turtle.suck()
        turtle.select(FUEL_ENDERCHEST)    
        turtle.drop()
        turtle.dig()
        turtle.select(1)
    end
    return turtle.getItemCount(FUEL_SLOT)
end
 
function refuel()
    turtle.select(FUEL_SLOT)
    turtle.refuel(1)
    while turtle.getItemCount(FUEL_SLOT) < 1 do
        if getFuelFromChest() < 1  then
            os.sleep(1)
        end
    end
    if not slotsEmpty() then
        storeStuff()
    end
end
 
function clear()
    term.clear()
    term.setCursorPos(1,1)
end
 
function up()
    while not turtle.up() do
        if turtle.getFuelLevel() < 10 then 
            refuel()
        end
        turtle.digUp()
    end
end
 
function down()
    while not turtle.down() do
        if turtle.getFuelLevel() < 10 then 
            refuel()
        end
        turtle.digDown()
    end
end
 
function forward()
    while not turtle.forward() do
        if turtle.getFuelLevel() < 10 then 
            refuel()
        end
        turtle.dig()
    end
end
 
function back()
    while not turtle.back() do
        if turtle.getFuelLevel() < 10 then 
            refuel()
        end
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.dig()
        turtle.turnLeft()
        turtle.turnLeft()
    end
end
 
function clearLine()
    for i = 1, depth do
        if turtle.getFuelLevel() < 10 then 
            refuel()
        end
 
        turtle.dig()
        forward()
        turtle.digUp()
        turtle.digDown()
    end
 
    for i = 1, depth do
        back()
    end
end
 
function clearWall()
    local i=1
    while i <= height do 
        if turtle.getFuelLevel() < 10 then 
            refuel()
        end
 
        if shouldDigUp then turtle.digUp() else turtle.digDown() end
 
        if i < height and i > 1  then
            if shouldDigUp then up() else down() end
            if shouldDigUp then turtle.digUp() else turtle.digDown() end
            i = i + 1 
        end
 
        if i < height  then
            if shouldDigUp then up() else down() end
            if shouldDigUp then turtle.digUp() else turtle.digDown() end
            i = i + 1 
        end
 
        clearLine()
        if shouldDigUp then up() else down() end
        i = i +1
    end
 
    for i = 1, height do
        if shouldDigUp then down() else up() end
    end
end
 
function clearCube()
    for i = 1, width do
        clearWall()
        turtle.turnRight()
        forward()
        turtle.turnLeft()
    end
 
    turtle.turnLeft()
 
    for i = 1, width+1 do
        forward()
    end
 
    turtle.turnRight()
end
 
tArgs = {...}
 
--print(tArgs[1] .. " " .. type(tArgs[1]) .. " " .. tArgs[2] .. " " .. type(tArgs[2]) .. " " .. tArgs[3] .. " " .. type(tArgs[3]))
 
if type(tArgs[1]) == "string" and type(tArgs[2]) == "string" and type(tArgs[3]) == "string" and tonumber(tArgs[1]) > 0 and tonumber(tArgs[2]) > 0 and tonumber(tArgs[3]) ~= 0 then
    depth = tonumber(tArgs[1])
    width = tonumber(tArgs[2])
    height = tonumber(tArgs[3])
else
    term.write("Insert depth: ")
    depth = tonumber(read())
    print(" ")
 
    term.write("Insert width: ")
    width = tonumber(read())
    print(" ")
 
    term.write("Insert height: ")
    height = tonumber(read())
    print(" ")
end
 
refuel()
 
if height < 0 then
    height = height * (-1)
    shouldDigUp = false
end
 
height = height -1
clearCube()