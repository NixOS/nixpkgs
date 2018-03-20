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
    then "ad62f9bb1d9722d32de61d7f610c5ac1385cc6b29609f9b8a84027e4c3e44d62"
    else if stdenv.system == "x86_64-linux"
    then "336cf7af6c857cdaa110e1425719fa3a1652351098dc73f156e5bf02ed86443c"
    else if stdenv.system == "i686-darwin"
    then "1223e885d388eff0e0acb4ca71b6b6fa64929c83354bacc1a36185bc38527e94"
    else if stdenv.system == "x86_64-darwin"
    then "1aecba7cab4bc1a9e0e931c04aa00849e930b567d243da7b676ede8f527a2992"
    else throw "missing bootstrap hash for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };

  # Note: the version  MUST be one version prior to the version we're
  # building
  version = "1.24.0";
in import ./binaryBuild.nix
  { inherit stdenv fetchurl makeWrapper cacert zlib buildRustPackage curl;
    inherit version src platform;
    versionType = "binary";
  }
