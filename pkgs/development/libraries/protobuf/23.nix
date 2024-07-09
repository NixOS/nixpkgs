{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "23.4";
  hash = "sha256-eI+mrsZAOLEsdyTC3B+K+GjD3r16CmPx1KJ2KhCwFdg=";
} // args)
