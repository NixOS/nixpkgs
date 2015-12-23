{ callPackage, pkgs }:
rec {
  budgie-desktop = callPackage ./budgie-desktop.nix { };
}
