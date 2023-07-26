{ callPackage, ... } @ args:

callPackage ./generic-v3-cmake.nix ({
  version = "3.24.2";
  sha256 = "sha256-yVLszyVtsz1CCzeOkioL4O3mWTFKKVBUyOhwDbC5UqE=";
} // args)
