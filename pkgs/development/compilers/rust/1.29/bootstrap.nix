{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.28.0";

  # fetch hashes by running `print-hashes.sh 1.24.1`
  hashes = {
    i686-unknown-linux-gnu = "de7cdb4e665e897ea9b10bf6fd545f900683296456d6a11d8510397bb330455f";
    x86_64-unknown-linux-gnu = "2a1390340db1d24a9498036884e6b2748e9b4b057fc5219694e298bdaa37b810";
    armv7-unknown-linux-gnueabihf = "346558d14050853b87049e5e1fbfae0bf0360a2f7c57433c6985b1a879c349a2";
    aarch64-unknown-linux-gnu = "9b6fbcee73070332c811c0ddff399fa31965bec62ef258656c0c90354f6231c1";
    i686-apple-darwin = "752e2c9182e057c4a54152d1e0b3949482c225d02bb69d9d9a4127dc2a65fb68";
    x86_64-apple-darwin = "5d7a70ed4701fe9410041c1eea025c95cad97e5b3d8acc46426f9ac4f9f02393";
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
