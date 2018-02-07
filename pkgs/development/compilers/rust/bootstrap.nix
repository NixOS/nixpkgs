{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.21.0";

  # fetch hashes by running `print-hashes.sh 1.21.0`
  hashes = {
    i686-unknown-linux-gnu = "b7caed0f602cdb8ef22e0bfa9125a65bec411e15c0b8901d937e43303ec7dbee";
    x86_64-unknown-linux-gnu = "b41e70e018402bc04d02fde82f91bea24428e6be432f0df12ac400cfb03108e8";
    armv7-unknown-linux-gnueabihf = "416fa6f107ad9e386002e6af1aec495472e2ee489c842183dd429a25b07488d6";
    aarch64-unknown-linux-gnu = "491ee6c43cc672006968d665bd34c94cc2219ef3592d93d38097c97eaaa864c3";
    i686-apple-darwin = "c8b0fabeebcde66b683f3a871187e614e07305adda414c2862cb332aecb2b3bf";
    x86_64-apple-darwin = "75a7f4bd7c72948030bb9e421df27e8a650dea826fb5b836cf59d23d6f985a0d";
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
