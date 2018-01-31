{ stdenv, fetchurl, makeWrapper, buildRustPackage, cacert, zlib, curl }:

let
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

  # fetch hashes by patching print-hashes.sh to not use the "$DATE" variable
  # then running `print-hashes.sh 1.16.0`
  bootstrapHash =
    if stdenv.system == "i686-linux"
    then "b7caed0f602cdb8ef22e0bfa9125a65bec411e15c0b8901d937e43303ec7dbee"
    else if stdenv.system == "x86_64-linux"
    then "b41e70e018402bc04d02fde82f91bea24428e6be432f0df12ac400cfb03108e8"
    else if stdenv.system == "i686-darwin"
    then "c8b0fabeebcde66b683f3a871187e614e07305adda414c2862cb332aecb2b3bf"
    else if stdenv.system == "x86_64-darwin"
    then "75a7f4bd7c72948030bb9e421df27e8a650dea826fb5b836cf59d23d6f985a0d"
    else throw "missing bootstrap hash for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };

  # Note: the version  MUST be one version prior to the version we're
  # building
  version = "1.21.0";
in import ./binaryBuild.nix
  { inherit stdenv fetchurl makeWrapper cacert zlib buildRustPackage curl;
    inherit version src platform;
    versionType = "binary";
  }
