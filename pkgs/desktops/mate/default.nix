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
  libmatekbd = callPackage ./libmatekbd { };
  libmatemixer = callPackage ./libmatemixer { };
  libmateweather = callPackage ./libmateweather { };
  marco = callPackage ./marco { };
  mate-common = callPackage ./mate-common { };
  mate-desktop = callPackage ./mate-desktop { };
  mate-icon-theme = callPackage ./mate-icon-theme { };
  mate-icon-theme-faenza = callPackage ./mate-icon-theme-faenza { };
  mate-menus = callPackage ./mate-menus { };
  mate-terminal = callPackage ./mate-terminal { };
  mate-themes = callPackage ./mate-themes { };
  pluma = callPackage ./pluma { };

  basePackages = [
    caja
    libmatekbd
    libmatemixer
    libmateweather
    marco
    mate-common
    mate-desktop
    mate-icon-theme
    mate-menus
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
