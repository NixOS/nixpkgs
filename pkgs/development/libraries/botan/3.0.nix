{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "3.2";
  revision = "0";
  hash = "sha256-BJyEeDX89u86niBrM94F3TiZnDJeJHSCdypVmNnl7OM=";
})
