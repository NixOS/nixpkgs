{ callPackage, fetchpatch, lib, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "3.1";
  revision = "1";
  sha256 = "sha256-MMhP6RmTapj+9TMfJGxiqiwOTSCFstRREgf2ogr6Oms=";
  # reconsider removing this platform marking, when MacOS uses Clang 14.0+ by default.
  badPlatforms = lib.platforms.darwin;
})
