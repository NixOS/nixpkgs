{ stdenv, fetchurl, makeWrapper, cacert, zlib, buildRustPackage, curl }:

let
  platform = if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else throw "missing bootstrap url for platform ${stdenv.system}";

  bootstrapHash =
    if stdenv.system == "x86_64-linux"
    then "0svlm4bxsdhdn4jsv46f278kid23a9w978q2137qrba4xnyb06kf"
    else throw "missing bootstrap hash for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/${version}/rust-nightly-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };

  version = "2017-06-26";
in import ./binaryBuild.nix
  { inherit stdenv fetchurl makeWrapper cacert zlib buildRustPackage curl;
    inherit version src platform;
    versionType = "nightly";
  }
