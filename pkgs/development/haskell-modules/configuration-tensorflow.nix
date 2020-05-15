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
    rev = "0f322b2e0611cbe7011c84ba8b6cb822e4725ebc";
    sha256 = "15gn66i547q20sd50ixwm6yk1g00syfgxp8xa6xjd0i3kcsl3gs1";
    fetchSubmodules = true;
  };

  setTensorflowSourceRoot = dir: drv:
    (overrideCabal drv (drv: { src = tensorflow-haskell; }))
      .overrideAttrs (_oldAttrs: {sourceRoot = "source/${dir}";});

  proto-lens = self.proto-lens_0_5_1_0;
  proto-lens-protoc = self.proto-lens-protoc_0_5_0_0;
  proto-lens-runtime = self.proto-lens-runtime_0_5_0_0;
  proto-lens-protobuf-types = self.proto-lens-protobuf-types_0_5_0_0;
  proto-lens-setup = self.proto-lens-setup_0_4_0_2;
  lens-family = self.lens-family_1_2_3;
in
{
  lens-family_1_2_3 = super.lens-family_1_2_3.override {
    lens-family-core = self.lens-family-core_1_2_3;
  };
  
  proto-lens_0_5_1_0 = (appendPatch (doJailbreak super.proto-lens_0_5_1_0) ./patches/proto-lens-0.5.1.0.patch).override {
    inherit lens-family;
  };

  proto-lens-runtime_0_5_0_0 = doJailbreak (super.proto-lens-runtime_0_5_0_0.override {
    inherit lens-family proto-lens;
  });

  proto-lens-protoc_0_5_0_0 = doJailbreak (super.proto-lens-protoc_0_5_0_0.override {
    inherit lens-family proto-lens;
    haskell-src-exts = self.haskell-src-exts_1_19_1;
  });
  proto-lens-setup_0_4_0_2 = appendPatch (doJailbreak (super.proto-lens-setup_0_4_0_2.override {
    inherit proto-lens-protoc;
  })) ./patches/proto-lens-setup-0.4.0.2.patch;

  proto-lens-protobuf-types_0_5_0_0 = doJailbreak (super.proto-lens-protobuf-types_0_5_0_0.override {
    inherit lens-family proto-lens proto-lens-runtime proto-lens-setup;
  });

  haskell-src-exts_1_19_1 = appendPatches (doJailbreak super.haskell-src-exts_1_19_1) [
    # Adapt to the Semigroup–Monoid Proposal (enables building on GHC >= 8.4)
    (pkgs.fetchpatch {
        url = "https://github.com/haskell-suite/haskell-src-exts/commit/258e072fe9e37f94360b7488b58ea2832843bbb8.patch";
        sha256 = "0ja6ai41v9plinlhjwja282m6ahn6mw4xi79np0jxqk83cg0z1ff";
    })
    # Adapt to MonadFail proposal (enables building on GHC >= 8.8)
    (pkgs.fetchpatch {
        url = "https://gist.githubusercontent.com/mikesperber/0f2addaf3fbe97ffb4a5234d8711ba41/raw/e09e20998283c7195e82d546ba9266d290eb000d/gistfile1.txt";
        sha256 = "18clvli7vpqsqlf2f3qidn71738j9zdlpana6wha3x0dxwan5ly0";
    }) ];

  tensorflow-proto = (setTensorflowSourceRoot "tensorflow-proto" super.tensorflow-proto).override {
    inherit proto-lens proto-lens-runtime proto-lens-setup proto-lens-protobuf-types;
  };

  tensorflow = (setTensorflowSourceRoot "tensorflow" super.tensorflow).override {
    inherit lens-family proto-lens;
    # the "regular" Python package does not seem to include the binary library
    libtensorflow = pkgs.libtensorflow-bin;
  };

  tensorflow-core-ops = (setTensorflowSourceRoot "tensorflow-core-ops" super.tensorflow-core-ops).override {
    inherit lens-family proto-lens;
  };

  tensorflow-logging = (setTensorflowSourceRoot "tensorflow-logging" super.tensorflow-logging).override {
    inherit lens-family proto-lens;
  };

  tensorflow-mnist = (setTensorflowSourceRoot "tensorflow-mnist" super.tensorflow-mnist).override {
    inherit lens-family proto-lens;
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

  tensorflow-opgen = (setTensorflowSourceRoot "tensorflow-opgen" super.tensorflow-opgen).override {
    inherit lens-family proto-lens;
  };

  tensorflow-ops = (setTensorflowSourceRoot "tensorflow-ops" super.tensorflow-ops).override {
    inherit lens-family proto-lens;
  };
}
