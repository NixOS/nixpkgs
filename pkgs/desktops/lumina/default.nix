{ pkgs, libsForQt5 }:

let
  packages = self: with self; {

    lumina = callPackage ./lumina { };

    preRequisitePackages = [
      pkgs.fluxbox
      pkgs.libsForQt5.kwindowsystem
      pkgs.numlockx
      pkgs.qt5.qtsvg
      pkgs.xscreensaver
    ];

    corePackages = [
      lumina
    ];

  };

in pkgs.lib.makeScope libsForQt5.newScope packages
