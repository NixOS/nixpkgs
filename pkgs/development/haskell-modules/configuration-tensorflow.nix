{ pkgs, haskellLib }:

with haskellLib;

self: super:
let
  # This contains updates to the dependencies, without which it would
  # be even more work to get it to build.
  # As of 2020-04, there's no new release in sight, which is why we're
  # pulling from Github.
  tensorflow-haskell = pkgs.fetchFromGitHub {
    owner = "tensorflow";
    repo = "haskell";
    rev = "568c9b6f03e5d66a25685a776386e2ff50b61aa9";
    sha256 = "0v58zhqipa441hzdvp9pwgv6srir2fm7cp0bq2pb5jl1imwyd37h";
    fetchSubmodules = true;
  };

  setTensorflowSourceRoot = dir: drv:
    (overrideCabal drv (drv: { src = tensorflow-haskell; }))
      .overrideAttrs (_oldAttrs: {sourceRoot = "source/${dir}";});
in
{
  tensorflow-proto = doJailbreak (setTensorflowSourceRoot "tensorflow-proto" super.tensorflow-proto);

  tensorflow = (setTensorflowSourceRoot "tensorflow" super.tensorflow).override {
    # the "regular" Python package does not seem to include the binary library
    libtensorflow = pkgs.libtensorflow-bin;
  };

  tensorflow-core-ops = setTensorflowSourceRoot "tensorflow-core-ops" super.tensorflow-core-ops;

  tensorflow-logging = setTensorflowSourceRoot "tensorflow-logging" super.tensorflow-logging;

  tensorflow-mnist = (setTensorflowSourceRoot "tensorflow-mnist" super.tensorflow-mnist).override {
    # https://github.com/tensorflow/haskell/issues/215
    tensorflow-mnist-input-data = self.tensorflow-mnist-input-data;
  };

  tensorflow-mnist-input-data = setTensorflowSourceRoot "tensorflow-mnist-input-data" (super.callPackage (
    { mkDerivation, base, bytestring, Cabal, cryptonite, directory
    , filepath, HTTP, network-uri, stdenv
    }:

    let
      fileInfos = {
        "train-images-idx3-ubyte.gz" = "440fcabf73cc546fa21475e81ea370265605f56be210a4024d2ca8f203523609";
        "train-labels-idx1-ubyte.gz" = "3552534a0a558bbed6aed32b30c495cca23d567ec52cac8be1a0730e8010255c";
        "t10k-images-idx3-ubyte.gz"  = "8d422c7b0a1c1c79245a5bcf07fe86e33eeafee792b84584aec276f5a2dbc4e6";
        "t10k-labels-idx1-ubyte.gz"  = "f7ae60f92e00ec6debd23a6088c31dbd2371eca3ffa0defaefb259924204aec6";
      };
      downloads = with pkgs.lib; flip mapAttrsToList fileInfos (name: sha256:
                    pkgs.fetchurl {
                      url = "http://yann.lecun.com/exdb/mnist/${name}";
                      inherit sha256;
                    });
    in
    mkDerivation {
      pname = "tensorflow-mnist-input-data";
      version = "0.1.0.0";
      enableSeparateDataOutput = true;
      setupHaskellDepends = [
        base bytestring Cabal cryptonite directory filepath HTTP
        network-uri
      ];
      preConfigure = pkgs.lib.strings.concatStringsSep "\n" (
          map (x: "ln -s ${x} data/$(stripHash ${x})") downloads
        );
      libraryHaskellDepends = [ base ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Downloader of input data for training MNIST";
      license = stdenv.lib.licenses.asl20;
    }
  ) {});

  tensorflow-opgen = setTensorflowSourceRoot "tensorflow-opgen" super.tensorflow-opgen;

  tensorflow-ops = setTensorflowSourceRoot "tensorflow-ops" super.tensorflow-ops;
}
