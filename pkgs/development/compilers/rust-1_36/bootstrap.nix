{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.36.0";

  # fetch hashes by running `print-hashes.sh 1.36.0`
  hashes = {
    i686-unknown-linux-gnu = "9f95c3e96622a792858c8a1c9274fa63e6992370493b27c1ac7299a3bec5156d";
    x86_64-unknown-linux-gnu = "15e592ec52f14a0586dcebc87a957e472c4544e07359314f6354e2b8bd284c55";
    armv7-unknown-linux-gnueabihf = "798181a728017068f9eddfa665771805d97846cd87bddcd67e0fe27c8d082ceb";
    aarch64-unknown-linux-gnu = "db78c24d93756f9fe232f081dbc4a46d38f8eec98353a9e78b9b164f9628042d";
    i686-apple-darwin = "3dbc34fdea8bc030badf9c8b2572c09fd3f5369b59ac099fc521064b390b9e60";
    x86_64-apple-darwin = "91f151ec7e24f5b0645948d439fc25172ec4012f0584dd16c3fb1acb709aa325";
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

in callPackage ./binary.nix
  { inherit version src platform;
    versionType = "bootstrap";
  }
