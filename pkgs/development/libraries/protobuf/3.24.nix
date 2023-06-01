{ callPackage, ... } @ args:

callPackage ./generic-v3-cmake.nix ({
  version = "3.24.1";
  sha256 = "sha256-70gKH18Ak3TJisscj8JsbOJavOFxbWbVEtGjTXUlqSI=";
} // args)
