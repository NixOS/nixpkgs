{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.25.0";

  # fetch hashes by running `print-hashes.sh 1.25.0`
  hashes = {
    i686-unknown-linux-gnu = "56c5ffdca29f8a3657d012d24644fd335405d7dac0b720b17f6321111f9c0e55";
    x86_64-unknown-linux-gnu = "06fb45fb871330a2d1b32a27badfe9085847fe824c189ddc5204acbe27664f5e";
    armv7-unknown-linux-gnueabihf = "3fc17d77c6d7d2053d0b376974b5d3d07994f71f419fd4eb03bfcb890186d7a5";
    aarch64-unknown-linux-gnu = "19a43451439e515a216d0a885d14203f9a92502ee958abf86bf7000a7d73d73d";
    i686-apple-darwin = "bc67b881b8c40f16640cf4e24da7b609feb4e4e1babaa0cce37a2fe33ca63633";
    x86_64-apple-darwin = "fcd0302b15e857ba4a80873360cf5453275973c64fa82e33bfbed02d88d0ad17";
  };

  platform =
    if stdenv.system == "i686-linux"
    then "i686-unknown-linux-gnu"
    else if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else if stdenv.system == "armv7l-linux"
    then "armv7-unknown-linux-gnueabihf"
    else if stdenv.system == "aarch64-linux"
    then "aarch64-unknown-linux-gnu"
    else if stdenv.system == "i686-darwin"
    then "i686-apple-darwin"
    else if stdenv.system == "x86_64-darwin"
    then "x86_64-apple-darwin"
    else throw "missing bootstrap url for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = hashes."${platform}";
  };

in callPackage ./binaryBuild.nix
  { inherit version src platform;
    buildRustPackage = null;
    versionType = "bootstrap";
  }
