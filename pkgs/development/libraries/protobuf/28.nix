{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "28.3";
    hash = "sha256-+bb5RxITzxuX50ItmpQhWEG1kMfvlizWTMJJzwlhhYM=";
  }
  // args
)
