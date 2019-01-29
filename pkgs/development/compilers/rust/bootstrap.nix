{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.31.1";

  # fetch hashes by running `print-hashes.sh 1.31.1`
  hashes = {
    i686-unknown-linux-gnu = "1e77e5e8c745320faad9ce6f319a77b4a2e75d972eb68a195acd081ad910ab6d";
    x86_64-unknown-linux-gnu = "a64685535d0c457f49a8712a096a5c21564cd66fd2f7da739487f028192ebe3c";
    armv7-unknown-linux-gnueabihf = "11c717b781a7af5bdc829894139f8f45d4c12a061f7f9e39481f21426a04eb21";
    aarch64-unknown-linux-gnu = "29a7c6eb536fefd0ca459e48dfaea006aa8bff8a87aa82a9b7d483487033632a";
    i686-apple-darwin = "46566dc25fcbd8badc9950b8c9f9b0faeca065b5a09cd96258e4f4b10d686aed";
    x86_64-apple-darwin = "8398b1b303bdf0e7605d08b87070a514a4f588797c6fb3593718cb9cec233ad6";
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
     sha256 = hashes."${platform}";
  };

in callPackage ./binaryBuild.nix
  { inherit version src platform;
    versionType = "bootstrap";
  }
