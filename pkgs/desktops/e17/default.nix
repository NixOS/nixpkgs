{ callPackage, pkgs }:
rec {
  #### CORE EFL

  eina = callPackage ./eina { };

  eet = callPackage ./eet { };

  evas = callPackage ./evas { };

  ecore = callPackage ./ecore { };

  eio = callPackage ./eio { };

  embryo = callPackage ./embryo { };

  edje = callPackage ./edje { lua = pkgs.lua5; };

  efreet = callPackage ./efreet { };

  e_dbus = callPackage ./e_dbus { };

  eeze = callPackage ./eeze { };

  emotion = callPackage ./emotion { };

  ethumb = callPackage ./ethumb { };

  elementary = callPackage ./elementary { };


  #### WINDOW MANAGER

  enlightenment = callPackage ./enlightenment { };


  #### APPLICATIONS




  #### ART




}
