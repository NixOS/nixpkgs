{
  lib,
  newScope,
}:
lib.makeScope newScope (self: {
  buildGuile = self.callPackage ./build-guile.nix { };
  guile_1_8 = self.callPackage ./1.8 { };
  guile_2_0 = self.callPackage ./2.0 { };
  guile_2_2 = self.callPackage ./2.2 { };
  guile_3_0 = self.callPackage ./3.0.nix { };
})
