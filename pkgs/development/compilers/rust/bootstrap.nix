{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.26.0";

  # fetch hashes by running `print-hashes.sh 1.24.1`
  hashes = {
    i686-unknown-linux-gnu = "2aef0709b1f2e93d396143b7a926f262ac6fd24dd8768bf2c9425255a4a401c1";
    x86_64-unknown-linux-gnu = "13691d7782577fc9f110924b26603ade1990de0b691a3ce2dc324b4a72a64a68";
    armv7-unknown-linux-gnueabihf = "d10c892cd3267010068930599e1e3835b50c6ba5261a912107dcba5ca1893ec5";
    aarch64-unknown-linux-gnu = "e12dc84bdb569cdb382268a5fe6ae6a8e2e53810cb890ec3a7133c20ba8451ac";
    i686-apple-darwin = "04dd24d7a5d5e02d5e992eaabd5952d39363885ce2a9980e3e96e5bc09dab2f0";
    x86_64-apple-darwin = "38708803c3096b8f101d1919ee2d7e723b0adf1bc1bb986b060973b57d8c7c28";
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
