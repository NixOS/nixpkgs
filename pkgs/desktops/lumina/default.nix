{ pkgs, libsForQt5 }:

let
  packages = self: with self; {

    lumina = callPackage ./lumina { };
    lumina-calculator = callPackage ./lumina-calculator { };
    lumina-pdf = callPackage ./lumina-pdf { };

    preRequisitePackages = [
      pkgs.fluxbox
      pkgs.libsForQt5.kwindowsystem
      pkgs.numlockx
      pkgs.qt5.qtsvg
      pkgs.xscreensaver
    ];

    corePackages = [
      lumina
      lumina-calculator
      lumina-pdf
    ];

  };

in pkgs.lib.makeScope libsForQt5.newScope packages
