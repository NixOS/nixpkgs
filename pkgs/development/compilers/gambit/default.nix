{ callPackage, fetchurl }:

callPackage ./build.nix rec {
  version = "4.9.3";
  git-version = version;
  src = fetchurl {
    url = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.9/source/gambit-v4_9_3.tgz";
    sha256 = "1p6172vhcrlpjgia6hsks1w4fl8rdyjf9xjh14wxfkv7dnx8a5hk";
  };
}
