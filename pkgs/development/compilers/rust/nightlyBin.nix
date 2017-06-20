{ stdenv, fetchurl, makeWrapper, cacert, zlib, buildRustPackage, curl }:

let
  platform = if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else throw "missing bootstrap url for platform ${stdenv.system}";

  bootstrapHash =
    if stdenv.system == "x86_64-linux"
    then "21f38f46bf16373d3240a38b775e1acff9bb429f1570a4d4da8b3000315d0085"
    else throw "missing bootstrap hash for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/${version}/rust-nightly-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };

  version = "2017-05-30";
in import ./binaryBuild.nix
  { inherit stdenv fetchurl makeWrapper cacert zlib buildRustPackage curl;
    inherit version src platform;
    versionType = "nightly";
  }
