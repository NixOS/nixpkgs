{ callPackage, pkgs }:
rec {
  mate-common = callPackage ./mate-common { };
  mate-desktop = callPackage ./mate-desktop { };
  mate-icon-theme = callPackage ./mate-icon-theme { };
  mate-icon-theme-faenza = callPackage ./mate-icon-theme-faenza { };
  mate-terminal = callPackage ./mate-terminal { };
  mate-themes = callPackage ./mate-themes { };
}
