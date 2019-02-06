{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.31.0";

  # fetch hashes by running `print-hashes.sh 1.31.0`
  hashes = {
    i686-unknown-linux-gnu = "46333e8feec55bc1f99fd03028370f6163ef1e33e483da0389a9c424ec9634ed";
    x86_64-unknown-linux-gnu = "c8a2016109ffdc12a488660edc5f30c1643729efc15abe311ebb187437e506bf";
    armv7-unknown-linux-gnueabihf = "60bb75649b457ad971e94dd14c666b59deeee2176b14ae0f98e2fa435c172c1e";
    aarch64-unknown-linux-gnu = "4e68c70aba58004d9e86c2b4463e88466affee51242349a038b456cf6f4be5c9";
    i686-apple-darwin = "ec8d08eeea97d78d37430e9b32511e87854aad502f4e3e77e806788246b36e6f";
    x86_64-apple-darwin = "5d4035e3cecb7df13e728bcff125b52b43b126e91f8311c66b143f353362606f";
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
     sha256 = hashes."${platform}";
  };

in callPackage ./binaryBuild.nix
  { inherit version src platform;
    versionType = "bootstrap";
  }
