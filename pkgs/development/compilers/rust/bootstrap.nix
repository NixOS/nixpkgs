{ stdenv, fetchurl, callPackage }:

let
  # Note: the version MUST be one version prior to the version we're
  # building
  version = "1.24.1";

  # fetch hashes by running `print-hashes.sh 1.24.1`
  hashes = {
    i686-unknown-linux-gnu = "a483576bb2ab237aa1ef62b66c0814f934afd8129d7c9748cb9a75da4a678c98";
    x86_64-unknown-linux-gnu = "4567e7f6e5e0be96e9a5a7f5149b5452828ab6a386099caca7931544f45d5327";
    armv7-unknown-linux-gnueabihf = "1169ab005b771c4befcdab536347a90242cae544b6b76eccd0f76796b61a534c";
    aarch64-unknown-linux-gnu = "64bb25a9689b18ddadf025b90d9bdb150b809ebfb74432dc69cc2e46120adbb2";
    i686-apple-darwin = "c96f7579e2406220895da80a989daaa194751c141e112ebe95761f2ed4ecb662";
    x86_64-apple-darwin = "9d4aacdb5849977ea619d399903c9378163bd9c76ea11dac5ef6eca27849f501";
  };

  platform =
    if stdenv.system == "i686-linux"
    then "i686-unknown-linux-gnu"
    else if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else if stdenv.system == "armv7l-linux"
    then "armv7-unknown-linux-gnueabihf"
    else if stdenv.system == "aarch64-linux"
    then "aarch64-unknown-linux-gnu"
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
