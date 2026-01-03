{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "33.1";
    hash = "sha256-IW6wLkr/NwIZy5N8s+7Fe9CSexXgliW8QSlvmUD+g5Q=";
  }
  // args
)
