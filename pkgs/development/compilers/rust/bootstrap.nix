{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.35.0";

  # fetch hashes by running `print-hashes.sh 1.34.2`
  hashes = {
    i686-unknown-linux-gnu = "05337776b3645e4b8c8c7ced0bcd1615cf9ad1b9c8b3d0f333620e5401e31aee";
    x86_64-unknown-linux-gnu = "cf600e2273644d8629ed57559c70ca8db4023fd0156346facca9ab3ad3e8f86c";
    armv7-unknown-linux-gnueabihf = "8f0f32d8ddc6fb7bcb8f50ec5e694078799d93facbf135eec5bd9a8c94d0c11e";
    aarch64-unknown-linux-gnu = "31e6da56e67838fd2874211ae896a433badf67c13a7b68481f1d5f7dedcc5952";
    i686-apple-darwin = "6a45ae8db094c5f6c57c5594a00f1a92b08c444a7347a657b4033186d4f08b19";
    x86_64-apple-darwin = "ac14b1c7dc330dcb53d8641d74ebf9b32aa8b03b9d650bcb9258030d8b10dbd6";
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
