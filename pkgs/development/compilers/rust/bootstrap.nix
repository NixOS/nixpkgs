{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.26.1";

  # fetch hashes by running `print-hashes.sh 1.24.1`
  hashes = {
    i686-unknown-linux-gnu = "d704ba5cbaaf93c5e2112d211630db0e460d5dc819a43464ba91581e5c821df3";
    x86_64-unknown-linux-gnu = "b7e964bace1286696d511c287b945f3ece476ba77a231f0c31f1867dfa5080e0";
    armv7-unknown-linux-gnueabihf = "34fbcebc8e60b6496f1ce7998cf0b50cd618770f039da529b65110fff1f25fa0";
    aarch64-unknown-linux-gnu = "d4a369053c2dfd5f457de6853557dab563944579fa4bb55bc919bacf259bff6d";
    i686-apple-darwin = "047c31a872161ebb1d21ef616f7658190403769a8734f84364a3cf15838b4708";
    x86_64-apple-darwin = "ebf898b9fa7e2aafc53682a41f18af5ca6660ebe82dd78f28cd9799fe4dc189a";
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
