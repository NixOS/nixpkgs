{ callPackage, pkgs }:
{
  #### CORE EFL
  efl = callPackage ./efl { };

  #### WINDOW MANAGER
  enlightenment = callPackage ./enlightenment { };

  #### APPLICATIONS
  econnman = callPackage ./econnman { };
  terminology = callPackage ./terminology { };
  rage = callPackage ./rage { };
  ephoto = callPackage ./ephoto { };
}
