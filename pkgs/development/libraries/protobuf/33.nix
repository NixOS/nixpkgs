{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "33.5";
    hash = "sha256-bn8wMZSAqukZyo+fLT4O044ld53FvIfCdajr2WwM93E=";
  }
  // args
)
