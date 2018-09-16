{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.26.2";

  # fetch hashes by running `print-hashes.sh 1.24.1`
  hashes = {
    i686-unknown-linux-gnu = "e22286190a074bfb6d47c9fde236d712a53675af1563ba85ea33e0d40165f755";
    x86_64-unknown-linux-gnu = "d2b4fb0c544874a73c463993bde122f031c34897bb1eeb653d2ba2b336db83e6";
    armv7-unknown-linux-gnueabihf = "1140387a61083e3ef10e7a097269200fc7e9db6f6cc9f270e04319b3b429c655";
    aarch64-unknown-linux-gnu = "3dfad0dc9c795f7ee54c2099c9b7edf06b942adbbf02e9ed9e5d4b5e3f1f3759";
    i686-apple-darwin = "3a5de30f3e334a66bd320ec0e954961d348434da39a826284e00d55ea60f8370";
    x86_64-apple-darwin = "f193705d4c0572a358670dbacbf0ffadcd04b3989728b442f4680fa1e065fa72";
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
