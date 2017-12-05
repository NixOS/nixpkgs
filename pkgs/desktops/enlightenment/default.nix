{ callPackage, pkgs }:
rec {
  #### CORE EFL
  efl = callPackage ./efl.nix { openjpeg = pkgs.openjpeg_1; };
  efl_1_19 = callPackage ./efl.nix { eflVersion = "1.19.1"; openjpeg = pkgs.openjpeg_1; };

  #### WINDOW MANAGER
  enlightenment = callPackage ./enlightenment.nix { };

  #### APPLICATIONS
  econnman = callPackage ./econnman.nix { };
  terminology = callPackage ./terminology.nix { };
  rage = callPackage ./rage.nix { };
  ephoto = callPackage ./ephoto.nix { efl = efl_1_19; };
}
