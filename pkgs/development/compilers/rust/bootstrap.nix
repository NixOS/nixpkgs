{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.23.0";

  # fetch hashes by running `print-hashes.sh 1.23.0`
  hashes = {
    i686-unknown-linux-gnu = "dc5bd0ef47e1036c8ca64676d8967102cb86ce4bf50b90a9845951c3e940423f";
    x86_64-unknown-linux-gnu = "9a34b23a82d7f3c91637e10ceefb424539dcfa327c2dcd292ff10c047b1fdc7e";
    armv7-unknown-linux-gnueabihf = "587027899267f1961520438c2c7f6775fe224160d43ddf07332b9b943a26b08e";
    aarch64-unknown-linux-gnu = "38379fbd976d2286cb73f21466db40a636a583b9f8a80af5eea73617c7912bc7";
    i686-apple-darwin = "4709eb1ad2fb871fdaee4b3449569cef366b0d170453cf17484a12286564f2ad";
    x86_64-apple-darwin = "9274e977322bb4b153f092255ac9bd85041142c73eaabf900cb2ef3d3abb2eba";
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
