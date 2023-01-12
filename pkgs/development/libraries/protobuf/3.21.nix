{ callPackage, ... } @ args:

callPackage ./generic-v3-cmake.nix ({
  version = "3.21.8";
  sha256 = "sha256-cSNHX18CvMmydpYWqfe6WWk9rGxIlFfY/85rfSyznU4=";
} // args)
