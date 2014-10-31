{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "9";
  sha256 = "0jgx5va042gmr6nc91p5dd59wnfxlz19mz2nnyv74pvwwmizs09m";
})
