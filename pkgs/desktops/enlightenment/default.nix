{ callPackage, pkgs }:
rec {
  #### CORE EFL
  efl = callPackage ./efl.nix { openjpeg = pkgs.openjpeg_1; };

  #### WINDOW MANAGER
  enlightenment = callPackage ./enlightenment.nix { };

  #### APPLICATIONS
  econnman = callPackage ./econnman.nix { };
  terminology = callPackage ./terminology.nix { };
  rage = callPackage ./rage.nix { };
}
