{ stdenv, fetchurl, fixDarwinDylibNames }:

let
  icu = import ./default.nix { inherit stdenv fetchurl fixDarwinDylibNames; };
in
  stdenv.lib.overrideDerivation icu (attrs: {
    src = fetchurl {
      url = "http://download.icu-project.org/files/icu4c/54.1/icu4c-54_1-src.tgz";
      sha256 = "1cwapgjmvrcv1n2wjspj3vahidg596gjfp4jn1gcb4baralcjayl";
    };
  })

