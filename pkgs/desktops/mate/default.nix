{ pkgs, newScope }:

let
  callPackage = newScope self;

  self = rec {

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
    mate-applets = callPackage ./mate-applets { };
    mate-backgrounds = callPackage ./mate-backgrounds { };
    mate-calc = callPackage ./mate-calc { };
    mate-common = callPackage ./mate-common { };
    mate-control-center = callPackage ./mate-control-center { };
    mate-desktop = callPackage ./mate-desktop { };
    mate-icon-theme = callPackage ./mate-icon-theme { };
    mate-icon-theme-faenza = callPackage ./mate-icon-theme-faenza { };
    mate-indicator-applet = callPackage ./mate-indicator-applet { };
    mate-media = callPackage ./mate-media { };
    mate-menus = callPackage ./mate-menus { };
    mate-netbook = callPackage ./mate-netbook { };
    mate-notification-daemon = callPackage ./mate-notification-daemon { };
    mate-panel = callPackage ./mate-panel { };
    mate-polkit = callPackage ./mate-polkit { };
    mate-power-manager = callPackage ./mate-power-manager { };
    mate-session-manager = callPackage ./mate-session-manager { };
    mate-settings-daemon = callPackage ./mate-settings-daemon { };
    mate-screensaver = callPackage ./mate-screensaver { };
    mate-system-monitor = callPackage ./mate-system-monitor { };
    mate-terminal = callPackage ./mate-terminal { };
    mate-themes = callPackage ./mate-themes { };
    mate-user-guide = callPackage ./mate-user-guide { };
    mate-utils = callPackage ./mate-utils { };
    pluma = callPackage ./pluma { };

    basePackages = [
      caja
      libmatekbd
      libmatemixer
      libmateweather
      marco
      mate-common
      mate-control-center
      mate-desktop
      mate-icon-theme
      mate-menus
      mate-notification-daemon
      mate-panel
      mate-polkit
      mate-session-manager
      mate-settings-daemon
      mate-themes
    ];

    extraPackages = [
      atril
      cajaWithExtensions
      engrampa
      eom
      mate-applets
      mate-backgrounds
      mate-calc
      mate-icon-theme-faenza
      mate-indicator-applet
      mate-media
      mate-netbook
      mate-power-manager
      mate-screensaver
      mate-system-monitor
      mate-terminal
      mate-user-guide
      mate-utils
      pluma
    ];
  
  };

in self
