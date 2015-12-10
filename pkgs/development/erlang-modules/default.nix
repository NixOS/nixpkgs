{ pkgs }: #? import <nixpkgs> {} }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = rec {
    buildErlang = callPackage ./build-erlang.nix {};
    buildHex = callPackage ./build-hex.nix {};

    rebar3-pc = callPackage ./hex/rebar3-pc.nix {};
    esqlite = callPackage ./hex/esqlite.nix {};
    goldrush = callPackage ./hex/goldrush.nix {};
    ibrowse = callPackage ./hex/ibrowse.nix {};
    jiffy = callPackage ./hex/jiffy.nix {};
    lager = callPackage ./hex/lager.nix {};
    meck = callPackage ./hex/meck.nix {};
  };
in self
