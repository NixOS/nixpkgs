{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "35.0";
    hash = "sha256-J0NA19W44CzgSjKv3A+1An6vDRTDjaWMhDzQGEOtrCk=";
  }
  // args
)
