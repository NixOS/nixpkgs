{ stdenv, fetchurl, fixDarwinDylibNames }:

let
  icu = import ./default.nix { inherit stdenv fetchurl fixDarwinDylibNames; };
in
  stdenv.lib.overrideDerivation icu (attrs: {
    src = fetchurl {
      url = "http://download.icu-project.org/files/icu4c/54.1/icu4c-54_1-src.tgz";
      md5 = "e844caed8f2ca24c088505b0d6271bc0";
    };
  })

