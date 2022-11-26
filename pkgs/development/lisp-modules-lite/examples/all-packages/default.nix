{ pkgs ? import ../../../../.. {} }:

# To build all packages:
#
#     nix-build
#
# To build only one package, e.g. alexandria:
#
#     nix-build -A alexandria

pkgs.lispPackagesLite
