{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.37.0";

  # fetch hashes by running `print-hashes.sh 1.37.0`
  hashes = {
    i686-unknown-linux-gnu = "74510e0e52a55e65a9f716673c2cda4d2bd427e2453541c6993c77c3ec04acf9";
    x86_64-unknown-linux-gnu = "cb573229bfd32928177c3835fdeb62d52da64806b844bc1095c6225b0665a1cb";
    armv7-unknown-linux-gnueabihf = "5b87b877f0ed20c6a09ce26e7a15d8c61b26b62484b97e78a51099d0efefec98";
    aarch64-unknown-linux-gnu = "263ef98fa3a6b2911b56f89c06615cdebf6ef676eb9b2493ad1539602f79b6ba";
    i686-apple-darwin = "e45d0c4d882fc6c404ffa6fe790294f4ea96384a2b48804adbf723f3635477a8";
    x86_64-apple-darwin = "b2310c97ffb964f253c4088c8d29865f876a49da2a45305493af5b5c7a3ca73d";
  };

  platform =
    if stdenv.hostPlatform.system == "i686-linux"
    then "i686-unknown-linux-gnu"
    else if stdenv.hostPlatform.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else if stdenv.hostPlatform.system == "armv7l-linux"
    then "armv7-unknown-linux-gnueabihf"
    else if stdenv.hostPlatform.system == "aarch64-linux"
    then "aarch64-unknown-linux-gnu"
    else if stdenv.hostPlatform.system == "i686-darwin"
    then "i686-apple-darwin"
    else if stdenv.hostPlatform.system == "x86_64-darwin"
    then "x86_64-apple-darwin"
    else throw "missing bootstrap url for platform ${stdenv.hostPlatform.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = hashes.${platform};
  };

in callPackage ./binary.nix
  { inherit version src platform;
    versionType = "bootstrap";
  }
