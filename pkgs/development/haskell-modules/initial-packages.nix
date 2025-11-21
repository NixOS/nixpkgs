args@{
  pkgs,
  lib,
  callPackage,
}:
self: (import ./hackage-packages.nix args self)
