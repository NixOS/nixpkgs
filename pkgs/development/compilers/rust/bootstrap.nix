{ stdenv, fetchurl, callPackage, version, hashes }:

let
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
