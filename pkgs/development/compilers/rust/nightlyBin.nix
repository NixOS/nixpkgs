{ stdenv, fetchurl, makeWrapper, cacert, zlib, buildRustPackage, curl }:

let
  platform = if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else throw "missing bootstrap url for platform ${stdenv.system}";

  bootstrapHash =
    if stdenv.system == "x86_64-linux"
    then "0x3mjq7xrjvfa28fjgd7ywmmm0yhj54cr09iimqazg7sfc9vq81k"
    else throw "missing bootstrap hash for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/${version}/rust-nightly-${platform}.tar.xz";
     sha256 = bootstrapHash;
  };

  version = "2017-08-02";
in import ./binaryBuild.nix
  { inherit stdenv fetchurl makeWrapper cacert zlib buildRustPackage curl;
    inherit version src platform;
    versionType = "nightly";
  }
