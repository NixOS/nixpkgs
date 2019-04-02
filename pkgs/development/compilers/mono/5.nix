{ callPackage, Foundation, libobjc }:

callPackage ./generic.nix (rec {
  inherit Foundation libobjc;
  version = "5.18.1.0";
  sha256 = "1w540f6r84shih0vrxa4h7q1ix1vx6zg0g10vcn95alg9ysqyam9";
  enableParallelBuilding = false;
})
