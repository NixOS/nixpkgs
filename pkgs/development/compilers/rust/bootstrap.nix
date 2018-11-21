{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.30.1";

  # fetch hashes by running `print-hashes.sh 1.30.0`
  hashes = {
    i686-unknown-linux-gnu = "c61655977fb16decf0ceb76043b9ae2190927aa9cc24f013d444384dcab99bbf";
    x86_64-unknown-linux-gnu = "a01a493ed8946fc1c15f63e74fc53299b26ebf705938b4d04a388a746dfdbf9e";
    armv7-unknown-linux-gnueabihf = "9b3b6df02a2a92757e4993a7357fdd02e07b60101a748b4618e6ae1b90bc1b6b";
    aarch64-unknown-linux-gnu = "6d87d81561285abd6c1987e07b60b2d723936f037c4b46eedcc12e8566fd3874";
    i686-apple-darwin = "a7c14b18e96406d9f43d69d0f984b2fa6f92cc7b7b37e2bb7b70b6f44b02b083";
    x86_64-apple-darwin = "3ba1704a7defe3d9a6f0c1f68792c084da83bcba85e936d597bac0c019914b94";
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
