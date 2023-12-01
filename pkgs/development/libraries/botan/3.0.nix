{ callPackage, fetchpatch, lib, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "3.2";
  revision = "0";
  sha256 = "BJyEeDX89u86niBrM94F3TiZnDJeJHSCdypVmNnl7OM=";
  # reconsider removing this platform marking, when MacOS uses Clang 14.0+ by default.
  badPlatforms = lib.platforms.darwin;
})
