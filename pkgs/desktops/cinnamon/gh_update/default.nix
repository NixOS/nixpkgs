{}:

let
  pkgs = import ../../../../. { };
  nixNodePackage = builtins.fetchGit {
    url = "git@github.com:mkg20001/nix-node-package";
    rev = "2b7a5d1dff02ca7f95e651c60476f17c720a3e72";
  };
  makeNode = import "${nixNodePackage}/nix/default.nix" pkgs {
    root = ./.;
    nodejs = pkgs.nodejs-10_x;
  };
in makeNode { }
