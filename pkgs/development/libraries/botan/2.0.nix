{ callPackage, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.19";
  revision = "3";
  sha256 = "sha256-2uBH85nFpH8IfbXT2dno8RrkmF0UySjXHaGv+AGALVU=";
})
