/* hex.nix is an auto-generated file -- DO NOT EDIT! */
{ callPackage }:

let
  self = rec {

  esqlite = callPackage
    ({ buildHex, rebar3-pc }:
     buildHex {
       name = "esqlite";
       version = "0.2.1";
       sha256 = "1296fn1lz4lz4zqzn4dwc3flgkh0i6n4sydg501faabfbv8d3wkr";
       compilePort = true;
    }) {};

  ibrowse = callPackage
    ({ buildHex, meck }:
      buildHex {
        name = "ibrowse";
        version = "4.2.2";
        sha256 = "1bn0645n95j5zypdsns1w4kgd3q9lz8fj898hg355j5w89scn05q";
        erlangDeps = [ meck ];
    }) {};

  meck = callPackage
    ({ stdenv, buildHex }:
     buildHex {
       name = "meck";
       version = "0.8.3";
       sha256 = "1dh2rhks1xly4f49x89vbhsk8fgwkx5zqp0n98mnng8rs1rkigak";

       meta = {
         description = "A mocking framework for Erlang";
         homepage = "https://github.com/eproxus/meck";
         license = stdenv.lib.licenses.apsl20;
      };
    }) {};

  goldrush = callPackage
    ({ buildHex, fetchurl }:
     buildHex {
       name = "goldrush";
       version = "0.1.7";
       sha256 = "1zjgbarclhh10cpgvfxikn9p2ay63rajq96q1sbz9r9w6v6p8jm9";
    }) {};

  jiffy = callPackage
    ({ buildHex }:
     buildHex {
       name = "jiffy";
       version = "0.14.5";
       hexPkg = "barrel_jiffy";
       sha256 = "0iqz8bp0f672c5rfy5dpw9agv2708wzldd00ngbsffglpinlr1wa";
     }) {};

  lager = callPackage
    ({ buildHex, goldrush }:
     buildHex {
       name = "lager";
       version = "3.0.2";
       sha256 = "0051zj6wfmmvxjn9q0nw8wic13nhbrkyy50cg1lcpdh17qiknzsj";
       erlangDeps = [ goldrush ];
    }) {};

  rebar3-pc = callPackage
    ({ buildHex, goldrush }:
     buildHex {
       name = "pc";
       version = "1.1.0";
       sha256 = "1br5xfl4b2z70b6a2ccxppn64jvkqgpmy4y9v81kxzb91z0ss9ma";
    }) {};
  };
in self
