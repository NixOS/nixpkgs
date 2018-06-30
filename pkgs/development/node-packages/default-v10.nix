{pkgs, system, nodejs, stdenv}:

let
  nodePackages = import ./composition-v10.nix {
    inherit pkgs system nodejs;
  };
in
nodePackages
