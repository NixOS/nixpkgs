{ stdenv, fetchurl, makeWrapper, cacert, zlib, curl }:

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
    then "b5859161ebb182d3b75fa14a5741e5de87b088146fb0ef4a30f3b2439c6179c5"
    else if stdenv.system == "x86_64-linux"
    then "48621912c242753ba37cad5145df375eeba41c81079df46f93ffb4896542e8fd"
    else if stdenv.system == "i686-darwin"
    then "26356b14164354725bd0351e8084f9b164abab134fb05cddb7758af35aad2065"
    else if stdenv.system == "x86_64-darwin"
    then "2d08259ee038d3a2c77a93f1a31fc59e7a1d6d1bbfcba3dba3c8213b2e5d1926"
    else throw "missing bootstrap hash for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };

  # Note: the version  MUST be one version prior to the version we're
  # building
  version = "1.16.0";
in import ./binaryBuild.nix
  { inherit stdenv fetchurl makeWrapper cacert zlib curl;
    buildRustPackage = null;
    inherit version src platform;
    versionType = "bootstrap";
  }
