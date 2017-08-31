{ callPackage, pkgs }:

rec {

  atril = callPackage ./atril { };
  caja = callPackage ./caja { };
  caja-extensions = callPackage ./caja-extensions { };
  cajaWithExtensions = callPackage ./caja/cajaWithExtensions.nix {
    extensions = [ caja-extensions ];
  };
  engrampa = callPackage ./engrampa { };
  eom = callPackage ./eom { };
  mate-common = callPackage ./mate-common { };
  mate-desktop = callPackage ./mate-desktop { };
  mate-icon-theme = callPackage ./mate-icon-theme { };
  mate-icon-theme-faenza = callPackage ./mate-icon-theme-faenza { };
  mate-terminal = callPackage ./mate-terminal { };
  mate-themes = callPackage ./mate-themes { };
  pluma = callPackage ./pluma { };

  basePackages = [
    caja
    mate-common
    mate-desktop
    mate-icon-theme
    mate-themes
  ];

  extraPackages = [
    atril
    cajaWithExtensions
    engrampa
    eom
    mate-icon-theme-faenza
    mate-terminal
    pluma
  ];
  
}
