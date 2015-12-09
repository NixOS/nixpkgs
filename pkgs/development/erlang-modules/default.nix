{ pkgs }: #? import <nixpkgs> {} }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = rec {
    buildErlang = callPackage ./build-erlang.nix {};
    buildHex = callPackage ./build-hex.nix {};

    # dependencies for ejabberd
    p1_utils = callPackage ./hex/p1_utils.nix {};
    cache_tab = callPackage ./hex/cache_tab.nix {};
    stringprep = callPackage ./hex/stringprep.nix {};
    p1_xml = callPackage ./hex/p1_xml.nix {};
    p1_tls = callPackage ./hex/p1_tls.nix {};
    p1_stun = callPackage ./hex/p1_stun.nix {};
    esip = callPackage ./hex/esip.nix {};
    p1_yaml = callPackage ./hex/p1_yaml.nix {};
    xmlrpc = callPackage ./hex/xmlrpc.nix {};
    jiffy = callPackage ./hex/jiffy.nix {};
    sync = callPackage ./hex/sync.nix {};
    erlang-katana = callPackage ./hex/erlang-katana.nix {};
    eper = callPackage ./hex/eper.nix {};

    goldrush = callPackage ./hex/goldrush.nix {};
    lager = callPackage ./hex/lager.nix {};
    getopt = callPackage ./hex/getopt.nix {};
    meck = callPackage ./hex/meck.nix {};
    ibrowse = callPackage ./hex/ibrowse.nix {};
    aleppo = callPackage ./hex/aleppo.nix {};
    zipper = callPackage ./hex/zipper.nix {};
    erlang-github = callPackage ./hex/erlang-github.nix {};

    elvis = callPackage ./hex/elvis.nix {};
    apns = callPackage ./hex/apns.nix {};
    appmon = callPackage ./hex/appmon.nix {};
  };
in self
