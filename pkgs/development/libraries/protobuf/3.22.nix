{ callPackage, ... } @ args:

callPackage ./generic-v3-cmake.nix ({
  version = "3.22.5";
  sha256 = "sha256-sbxl9uUFvTgczzdv7UkJHjACXYLF2FHGmhZEE8lFLs4=";
} // args)
