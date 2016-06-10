{ callPackage, pkgs }:
rec {
  mate-common = callPackage ./mate-common { };
  mate-icon-theme = callPackage ./mate-icon-theme { };
  mate-icon-theme-faenza = callPackage ./mate-icon-theme-faenza { };
  mate-themes = callPackage ./mate-themes { };
}
