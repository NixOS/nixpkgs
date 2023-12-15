{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "25.1";
  hash = "sha256-w6556kxftVZ154LrZB+jv9qK+QmMiUOGj6EcNwiV+yo=";
} // args)
