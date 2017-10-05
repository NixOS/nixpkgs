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
  # then running `print-hashes.sh 1.18.0`
  bootstrapHash =
    if stdenv.system == "i686-linux"
    then "821ced1bd5a8e89322f20c3565ef50a3708faca047d21686d4a2139f6dc0b1d6"
    else if stdenv.system == "x86_64-linux"
    then "abdc9f37870c979dd241ba8c7c06d8bb99696292c462ed852c0af7f988bb5887"
    else if stdenv.system == "i686-darwin"
    then "977aaad697a995e28c6d9511fd8301d236da48978f8f3b938d8f22f105e4bf2f"
    else if stdenv.system == "x86_64-darwin"
    then "30f210e3133121812d74995a2831cfb3fe79c271b3cb1721815943bd4f7eb297"
    else throw "missing bootstrap hash for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };

  # Note: the version  MUST be one version prior to the version we're
  # building
  version = "1.18.0";
in import ./binaryBuild.nix
  { inherit stdenv fetchurl makeWrapper cacert zlib curl;
    buildRustPackage = null;
    inherit version src platform;
    versionType = "bootstrap";
  }
