{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.20.0";

  # fetch hashes by running `print-hashes.sh 1.20.0`
  hashes = {
    i686-unknown-linux-gnu = "abe592e06616cdc2fcca56ddbe482050dd49a1fada35e2af031c64fe6eb14668";
    x86_64-unknown-linux-gnu = "ca1cf3aed73ff03d065a7d3e57ecca92228d35dc36d9274a6597441319f18eb8";
    i686-apple-darwin = "b3c2470f8f132d285e6c989681e251592b67071bc9d93cac8a2e6b66f7bdfcb5";
    x86_64-apple-darwin = "fa1fb8896d5e327cbe6deeb50e6e9a3346de629f2e6bcbd8c10f19f3e2ed67d5";
  };

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

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = hashes."${platform}";
  };

in callPackage ./binaryBuild.nix
  { inherit version src platform;
    buildRustPackage = null;
    versionType = "bootstrap";
  }
