{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.33.0";

  # fetch hashes by running `print-hashes.sh 1.33.0`
  hashes = {
    i686-unknown-linux-gnu = "c379203687d98e60623aa88c4df4992dd5a9548bc30674b9fc8e671a979e9f3a";
    x86_64-unknown-linux-gnu = "6623168b9ee9de79deb0d9274c577d741ea92003768660aca184e04fe774393f";
    armv7-unknown-linux-gnueabihf = "f6f0ec0a98d922c4bfd79703bc9e9eef439ba347453f33608a87cd63c47e7245";
    aarch64-unknown-linux-gnu = "a308044e4076b62f637313ea803fa0a8f340b0f1b53136856f2c43afcabe5387";
    i686-apple-darwin = "ed20809d56bbaea041721ce6fc9f10f7ae7a720c5821587f01a537d07a5454b1";
    x86_64-apple-darwin = "864e7c074a0b88e38883c87c169513d072300bb52e1d320a067bd34cf14f66bd";
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
