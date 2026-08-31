{
  lib,
  newScope,
}:

lib.makeScope newScope (self: {
  image = self.callPackage ./image.nix { };
  data = self.callPackage ./data.nix { };
  game = self.callPackage ./game.nix { };
})
