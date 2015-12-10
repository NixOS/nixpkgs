{ pkgs }: #? import <nixpkgs> {} }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = rec {
    buildErlang = callPackage ./build-erlang.nix {};
    buildHex = callPackage ./build-hex.nix {};

    goldrush = callPackage ./hex/goldrush.nix {};
    ibrowse = callPackage ./hex/ibrowse.nix {};
    jiffy = callPackage ./hex/jiffy.nix {};
    lager = callPackage ./hex/lager.nix {};
    meck = callPackage ./hex/meck.nix {};
  };
in self
