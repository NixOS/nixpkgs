{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.40.0";

  # fetch hashes by running `print-hashes.sh 1.40.0`
  hashes = {
    i686-unknown-linux-gnu = "d050d3a1c7c45ba9c50817d45bf6d7dd06e1a4d934f633c8096b7db6ae27adc1";
    x86_64-unknown-linux-gnu = "fc91f8b4bd18314e83a617f2389189fc7959146b7177b773370d62592d4b07d0";
    armv7-unknown-linux-gnueabihf = "ebfe3978e12ffe34276272ee6d0703786249a9be80ca50617709cbfdab557306";
    aarch64-unknown-linux-gnu = "639271f59766d291ebdade6050e7d05d61cb5c822a3ef9a1e2ab185fed68d729";
    i686-apple-darwin = "ea189b1fb0bfda367cde6d43c18863ab4c64ffca04265e5746bf412a186fe1a2";
    x86_64-apple-darwin = "749ca5e0b94550369cc998416b8854c13157f5d11d35e9b3276064b6766bcb83";
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
