{system ? builtins.currentSystem, pkgs ? import <nixpkgs> {
    inherit system;
  }, overrides ? {}}:

let
  nodeEnv = import ./node-env.nix {
    inherit (pkgs) stdenv fetchurl nodejs python utillinux runCommand;
  };
  registry = (import ./registry.nix {
    inherit (nodeEnv) buildNodePackage;
    inherit (pkgs) fetchurl fetchgit;
    self = registry;
  }) // overrides;
in
registry