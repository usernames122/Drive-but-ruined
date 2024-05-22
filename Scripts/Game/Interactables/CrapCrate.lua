dofile("$CONTENT_DATA/Scripts/Game/CrapCrateLoot.lua")

CrapCrate = class()

function CrapCrate:server_onMelee() 
  self:sv_open()
end

function CrapCrate:server_onExplosion() 
  --self:sv_open()
  -- Crates might accidentally kaboom itself, so i disabled it
end

function CrapCrate:server_onProjectile()
  self:sv_open()
end
function CrapCrate:server_onCreate()
  local position = self.shape.getWorldPosition(self.shape)
  sm.physics.explode({
    position = position + sm.vec3.new(0,10,0),          -- Replace with the desired position vector (e.g., sm.vec3.new(x, y, z))
    10,                       -- Set destruction level to 10 to destroy all blocks except those with quality level 10
     10,           -- Set the destruction radius to 15
    0,                -- Set impulse radius to 0 to prevent any push effects
    0,                    -- Set magnitude to 0 to prevent any impulse effects
      -- No additional parameters
})
end
function CrapCrate:sv_open() 
  local position = self.shape.getWorldPosition(self.shape)

  sm.effect.playEffect("Lootbox - Break", position)

  sm.shape.destroyShape(self.shape, 0)

  for i = 1, math.random(2, 4) do
    local angle = math.random() * math.pi * 2

    local vel = sm.vec3.new( 1, 4.0, 0.0 )
    vel = vel:rotateY(angle)

    local crap = GetRandomCrap()

    local params = { lootUid = crap.uid, lootQuantity = crap.stackSize }

    sm.projectile.shapeCustomProjectileAttack(params, sm.uuid.new("45209992-1a59-479e-a446-57140b605836"), 0, sm.vec3.new( 0, 0, 0 ), vel, self.shape, 0)
  end
end
