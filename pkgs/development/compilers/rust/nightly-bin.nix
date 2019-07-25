{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "2019-07-24";

  # fetch hashes by running `print-hashes.sh nightly 2019-07-24`
  hashes = {
    i686-unknown-linux-gnu = "0c6f1fc6c44fbd1edae89fcc448d8fb39cffb3b162c8eac958cf3de503eecd37";
    x86_64-unknown-linux-gnu = "0cb9d47bd1bd8fa2df8879b2658ef11a7bf825cee4c23325c07a2de7698cde3b";
    armv7-unknown-linux-gnueabihf = "7960aae6ec8d9c5732cef90a2dbb1cda6458f7bd1e4be99371e426927634e50f";
    aarch64-unknown-linux-gnu = "c6c7dbe881d0c24b640cd722b7ec8ac5121659606c5d0a1664748bda32eccca2";
    i686-apple-darwin = "755661052712dabcf319046255958810be3caeefe9a879ebab030d691a9d627d";
    x86_64-apple-darwin = "a9ab691252ce957c572a7203b549315c07989b2c13b9aefa3143671f766625d8";
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
    url = "https://static.rust-lang.org/dist/${version}/rust-nightly-${platform}.tar.gz";
    sha256 = hashes."${platform}";
  };

in callPackage ./binaryBuild.nix
  { inherit version src platform;
    versionType = "nightly";
  }
