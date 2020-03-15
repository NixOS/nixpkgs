{ nixpkgs ? import ../../.. {} }:
with nixpkgs;
mkShell {
  buildInputs = [
    bash nodePackages.node2nix
  ];
  NODE_NIXPKGS_PATH = builtins.toString ../../../.;
}
