{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.29.2";

  # fetch hashes by running `print-hashes.sh 1.29.2`
  hashes = {
    i686-unknown-linux-gnu = "fd67338c32348fc0cf09dd066975acc221e062fdc3b052912baef93b39a0b27e";
    x86_64-unknown-linux-gnu = "e9809825c546969a9609ff94b2793c9107d7d9bed67d557ed9969e673137e8d8";
    armv7-unknown-linux-gnueabihf = "943ee757d96be97baccb84b0c2a5da368f8f3adf082805b0f0323240e80975c0";
    aarch64-unknown-linux-gnu = "e11461015ca7106ef8ebf00859842bf4be518ee170226cb8eedaaa666946509f";
    i686-apple-darwin = "aadec39efcbc476e00722b527dcc587003ab05194efd06ba1b91c1e0f7512d3f";
    x86_64-apple-darwin = "63f54e3013406b39fcb5b84bcf5e8ce85860d0b97a1e156700e467bf5fb5d5f2";
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
