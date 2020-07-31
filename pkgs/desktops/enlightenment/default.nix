{ callPackage, pkgs }:
{
  #### CORE EFL
  efl = callPackage ./efl.nix { };

  #### WINDOW MANAGER
  enlightenment = callPackage ./enlightenment.nix { };

  #### APPLICATIONS
  econnman = callPackage ./econnman.nix { };
  terminology = callPackage ./terminology.nix { };
  rage = callPackage ./rage.nix { };
  ephoto = callPackage ./ephoto.nix { };
}
