{ stdenv, callPackage, fetchurl }:

callPackage ./build.nix {
  version = "4.9.3";
  src = fetchurl {
    url = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.9/source/gambit-v4_9_3.tgz";
    sha256 = "1p6172vhcrlpjgia6hsks1w4fl8rdyjf9xjh14wxfkv7dnx8a5hk";
  };
  inherit stdenv;
}
