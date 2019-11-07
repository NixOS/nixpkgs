{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.38.0";

  # fetch hashes by running `print-hashes.sh 1.38.0`
  hashes = {
    i686-unknown-linux-gnu = "41aed8a350e24a0cac1444ed99b3dd24a90bc581dd88cb420c6e547d6b5f57af";
    x86_64-unknown-linux-gnu = "adda26b3f0609dbfbdc2019da4a20101879b9db2134fae322a4e863a069ec221";
    armv7-unknown-linux-gnueabihf = "8b1bf1680a61a643d6b5c7a3b1a1ce88448652756395e20ba5846739cbd085c4";
    aarch64-unknown-linux-gnu = "06afd6d525326cea95c3aa658aaa8542eab26f44235565bb16913ac9d12b7bda";
    i686-apple-darwin = "cdbf2807774bed350a3af6f41d7f7dd7ceff28777cde310c3ba90033188eb2f8";
    x86_64-apple-darwin = "bd301b78ddcd5d4553962b115e1dca5436dd3755ed323f86f4485769286a8a5a";
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
     sha256 = hashes.${platform};
  };

in callPackage ./binary.nix
  { inherit version src platform;
    versionType = "bootstrap";
  }
