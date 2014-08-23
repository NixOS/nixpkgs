{ callPackage, pkgs }:
rec {
  #### CORE EFL
  efl = callPackage ./efl.nix { };
  evas = callPackage ./evas.nix { };
  emotion = callPackage ./emotion.nix { };
  elementary = callPackage ./elementary.nix { };

  #### WINDOW MANAGER
  enlightenment = callPackage ./enlightenment.nix { };

  #### APPLICATIONS
  econnman = callPackage ./econnman.nix { };
  terminology = callPackage ./terminology.nix { };

}
