{ callPackage, Foundation, libobjc }:

callPackage ./generic.nix (rec {
  inherit Foundation libobjc;
  version = "5.20.1.27";
  sha256 = "15rpwxw642ad1na93k5nj7d2lb24f21kncr924gxr00178a9x0jy";
  enableParallelBuilding = true;
})
