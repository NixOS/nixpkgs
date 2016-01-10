{ pkgs }: #? import <nixpkgs> {} }:

let
  self = rec {
    hex = import ./hex-packages.nix { callPackage = self.callPackage; };
    callPackage = pkgs.lib.callPackageWith (pkgs // self // hex);
    buildErlang = callPackage ./build-erlang.nix {};
    buildHex = callPackage ./build-hex.nix {};
  };
in self // self.hex
