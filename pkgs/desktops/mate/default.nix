{ callPackage, pkgs }:
rec {
  mate-common = callPackage ./mate-common { };
  mate-icon-theme-faenza = callPackage ./mate-icon-theme-faenza { };
}
