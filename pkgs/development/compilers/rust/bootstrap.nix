{ stdenv, fetchurl, makeWrapper, cacert, zlib, curl }:

let
  platform =
    if stdenv.system == "i686-linux"
    then "i686-unknown-linux-gnu"
    else if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else if stdenv.system == "i686-darwin"
    then "i686-apple-darwin"
    else if stdenv.system == "x86_64-darwin"
    then "x86_64-apple-darwin"
    else throw "missing bootstrap url for platform ${stdenv.system}";

  # fetch hashes by running `print-hashes.sh 1.17.0`
  bootstrapHash =
    if stdenv.system == "i686-linux"
    then "39d16ce0f618ba37ee1024b83e4822a2d38e6ba9f341ff2020d34df94c7a6beb"
    else if stdenv.system == "x86_64-linux"
    then "bbb0e249a7a3e8143b569706c7d2e7e5f51932c753b7fd26c58ccd2015b02c6b"
    else if stdenv.system == "i686-darwin"
    then "308132b33d4002f95a725c2d31b975ff37905e3644894ed86e614b03ded70265"
    else if stdenv.system == "x86_64-darwin"
    then "1689060c07ec727e9756f19c9373045668471ab56fd8f53e92701150bbe2032b"
    else throw "missing bootstrap hash for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };

  version = "1.17.0";
in import ./binaryBuild.nix
  { inherit stdenv fetchurl makeWrapper cacert zlib curl;
    buildRustPackage = null;
    inherit version src platform;
    versionType = "bootstrap";
  }
