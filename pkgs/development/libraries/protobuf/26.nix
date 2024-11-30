{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "26.1";
    hash = "sha256-9sA+MYeDqRZl1v6HV4mpy60vqTbVTtinp9er6zkg/Ng=";
  }
  // args
)
