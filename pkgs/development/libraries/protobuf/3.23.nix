{ callPackage, ... } @ args:

callPackage ./generic-v3-cmake.nix ({
  version = "3.23.4";
  sha256 = "sha256-eI+mrsZAOLEsdyTC3B+K+GjD3r16CmPx1KJ2KhCwFdg=";
} // args)
