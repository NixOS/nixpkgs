{ callPackage, pkgs }:
rec {
  #### CORE EFL

  eina = callPackage ./eina { };

  eet = callPackage ./eet { };

  evas = callPackage ./evas { };

  ecore = callPackage ./ecore { };

  embryo = callPackage ./embryo { };

  edje = callPackage ./edje { lua = pkgs.lua5; };

  efreet = callPackage ./efreet { };

  e_dbus = callPackage ./e_dbus { };

  eeze = callPackage ./eeze { };


  #### WINDOW MANAGER

  enlightenment = callPackage ./enlightenment { };


  #### APPLICATIONS




  #### ART




}
