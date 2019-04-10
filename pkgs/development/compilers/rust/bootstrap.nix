{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.32.0";

  # fetch hashes by running `print-hashes.sh 1.32.0`
  hashes = {
    i686-unknown-linux-gnu = "4ce3a6a656669fa86606074b43fadeac7465ef48394249407e21106ed714c8db";
    x86_64-unknown-linux-gnu = "e024698320d76b74daf0e6e71be3681a1e7923122e3ebd03673fcac3ecc23810";
    armv7-unknown-linux-gnueabihf = "d7b69f60689d2905d8d3c2829b0f1cd0f86265a255ff88ea0deb601aebac6428";
    aarch64-unknown-linux-gnu = "60def40961728212da4b3a9767d5a2ddb748400e150a5f8a6d5aa0e1b8ba1cee";
    i686-apple-darwin = "76cc1280f6b61bf7cf1fddd5202cc236db7573ee05f39fc8cd12ddda8f39a7c3";
    x86_64-apple-darwin = "f0dfba507192f9b5c330b5984ba71d57d434475f3d62bd44a39201e36fa76304";
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
