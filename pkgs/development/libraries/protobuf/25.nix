{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "25.7";
    hash = "sha256-tCl37I/6iXtfGPw/HVZYdudJWYdzPfnN7piLDpR/bgk=";
  }
  // args
)
