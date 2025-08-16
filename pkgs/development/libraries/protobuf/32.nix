{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "32.0";
    hash = "sha256-kiA0P6ZU0i9vxpNjlusyMsFkvDb5DkoiH6FwE/q8FMI=";
  }
  // args
)
