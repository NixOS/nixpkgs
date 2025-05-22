{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "31.0";
    hash = "sha256-Y1qTHFl9xItaIs5u3mr+US1d1KmIfVJXqC7q4AA2U/w=";
  }
  // args
)
