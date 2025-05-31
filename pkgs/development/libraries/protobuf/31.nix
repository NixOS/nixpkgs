{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "31.1";
    hash = "sha256-E8q8XupOXoCFpXyGNHArfBmVm6ebfDgaJlJyvMqpveU=";
  }
  // args
)
