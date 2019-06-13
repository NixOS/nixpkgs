{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.34.2";

  # fetch hashes by running `print-hashes.sh 1.34.2`
  hashes = {
    i686-unknown-linux-gnu = "926bafd09eb90ba7d5a0195fcffb8f33dd57e515af4f8987a143459f6b1d3f04";
    x86_64-unknown-linux-gnu = "2bf6622d980a52832bae141304e96f317c8a1ccd2dfd69a134a14033e6e43c0f";
    armv7-unknown-linux-gnueabihf = "70d1057fcc133dc3e44377060a00d2f9d3a134e2670963d3f1d93f3dbfa0548e";
    aarch64-unknown-linux-gnu = "15fc6b7ec121df9d4e42483dd12c677203680bec8c69b6f4f62e5a35a07341a8";
    i686-apple-darwin = "b9fc44cbb06050975664f1033d1337bb38d5ea73b503a5d3af5409033397be5c";
    x86_64-apple-darwin = "6fdd4bf7fe26dded0cd57b41ab5f0500a5a99b7bc770523a425e9e34f63d0fd8";
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
