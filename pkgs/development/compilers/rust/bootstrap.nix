{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.30.0";

  # fetch hashes by running `print-hashes.sh 1.30.0`
  hashes = {
    i686-unknown-linux-gnu = "4ceb0e3011d96504587abb7edfdea9c1b4b7cb2c4488cc4a25adc2f3b6a88b21";
    x86_64-unknown-linux-gnu = "f620e3125cc505c842150bd873c0603432b6cee984cdae8b226cf92c8aa1a80f";
    armv7-unknown-linux-gnueabihf = "63991f6769ca8db693562c34ac25473e9d4f9f214d6ee98917891be469d69cfd";
    aarch64-unknown-linux-gnu = "9690c7c50eba5a8461184ee4138b4c284bad31ccc4aa1f2ddeec58b253e6363e";
    i686-apple-darwin = "b8e5ac31f0a192a58b0e98ff88c47035a2882598946352fa5a86c28ede079230";
    x86_64-apple-darwin = "07008d90932712282bc599f1e9a226e97879c758dc1f935e6e2675e45694cc1b";
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
    buildRustPackage = null;
    versionType = "bootstrap";
  }
