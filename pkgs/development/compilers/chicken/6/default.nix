{
  lib,
  newScope,
}:
lib.makeScope newScope (self: {

  chicken = self.callPackage ./chicken.nix { };

})
