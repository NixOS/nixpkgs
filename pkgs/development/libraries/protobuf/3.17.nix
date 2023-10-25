{ callPackage, ... } @ args:

callPackage ./generic-v3.nix ({
  version = "3.17.3";
  sha256 = "08644kaxhpjs38q5q4fp01yr0wakg1ijha4g3lzp2ifg7y3c465d";
} // args)
