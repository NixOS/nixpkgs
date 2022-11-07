{ pkgs ? import ../../../../.. {} }:

# To test all packages:
#
#     nix-build
#
# To test only one package, e.g. alexandria:
#
#     nix-build -A alexandria

pkgs.lib.pipe pkgs.lispPackagesLite.lispPackages [
  (pkgs.lib.attrsets.filterAttrs (n: pkgs.lib.attrsets.isDerivation))
  (builtins.mapAttrs (k: v: v.enableCheck))
]
