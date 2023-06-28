{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
    name = "cairo-lang";
    shellHook = ''
      nix-build derivation.nix
      PATH=$PATH:$(readlink -f ./result)/bin/
    '';
}
