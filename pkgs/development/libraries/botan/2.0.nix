{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.19";
  revision = "4";
  hash = "sha256-WjqI72Qz6XvKsO+h7WDGGX5K2p2dMLwcR0N7+JuX8nY=";
})
