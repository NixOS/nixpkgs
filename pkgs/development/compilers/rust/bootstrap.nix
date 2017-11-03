{ stdenv, fetchurl, makeWrapper, cacert, zlib, curl }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.19.0";

  # fetch hashes by running `print-hashes.sh 1.19.0`
  hashes = {
    i686-unknown-linux-gnu = "657b78f3c1a1b4412e12f7278e20cc318022fa276a58f0d38a0d15b515e39713";
    x86_64-unknown-linux-gnu = "30ff67884464d32f6bbbde4387e7557db98868e87fb2afbb77c9b7716e3bff09";
    i686-apple-darwin = "bdfd2189245dc5764c9f26bdba1429c2bf9d57477d8e6e3f0ba42ea0dc63edeb";
    x86_64-apple-darwin = "5c668fb60a3ba3e97dc2cb8967fc4bb9422b629155284dcb89f94d116bb17820";
  };

  platform =
    if stdenv.system == "i686-linux"
    then "i686-unknown-linux-gnu"
    else if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else if stdenv.system == "i686-darwin"
    then "i686-apple-darwin"
    else if stdenv.system == "x86_64-darwin"
    then "x86_64-apple-darwin"
    else throw "missing bootstrap url for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = hashes."${platform}";
  };

in import ./binaryBuild.nix
  { inherit stdenv fetchurl makeWrapper cacert zlib curl;
    buildRustPackage = null;
    inherit version src platform;
    versionType = "bootstrap";
  }
