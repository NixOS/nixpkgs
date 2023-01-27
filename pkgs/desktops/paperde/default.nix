{ pkgs, makeScope, libsForQt5, qt5 }:
let
  packages = self: with self; {

    login1 = callPackage ./login1 { };
    ipc = callPackage ./ipc { };
    status-notifier = callPackage ./status-notifier { };
    wayqt = callPackage ./wayqt { };
    applications = callPackage ./applications { inherit ipc; };
    paper-desktop = callPackage ./desktop { inherit wayqt status-notifier ipc applications login1; };

    corePackages = [
      login1
      ipc
      status-notifier
      wayqt
      applications
      paper-desktop
    ];
  };
in
makeScope libsForQt5.newScope packages
