{ lib, pkgs }:

lib.makeScope pkgs.newScope (
  self: with self; {

    #### CORE EFL
    efl = callPackage ./efl { };

    #### WINDOW MANAGER
    enlightenment = callPackage ./enlightenment { };

    #### APPLICATIONS
    econnman = callPackage ./econnman { };
    ecrire = callPackage ./ecrire { };
    ephoto = callPackage ./ephoto { };
    evisum = callPackage ./evisum { };
    rage = callPackage ./rage { };
    terminology = callPackage ./terminology { };

  }
)
