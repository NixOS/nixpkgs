{ pkgs, haskellLib }:

with haskellLib;

self: super:
let
  tensorflow-haskell = pkgs.fetchFromGitHub {
    owner = "tensorflow";
    repo = "haskell";
    rev = "85bf0bb12cecfcdfcf31dea43b67cbe44576f685";
    sha256 = "1xbwc8y4a7n2163g746dpyh1q86rbxaw3d41kcy1mbhvmfqq56x7";
    fetchSubmodules = true;
  };

  setSourceRoot = dir: drv: drv.overrideAttrs (_oldAttrs: {sourceRoot = "source/${dir}";});

  proto-lens = self.proto-lens_0_2_2_0;
  proto-lens-protoc = self.proto-lens-protoc_0_2_2_3;
  proto-lens-protobuf-types = self.proto-lens-protobuf-types_0_2_2_0;
  mainland-pretty = self.mainland-pretty_0_6_2;
in
{
  proto-lens_0_2_2_0 = appendPatch super.proto-lens_0_2_2_0 ./patches/proto-lens-0.2.2.0.patch;
  proto-lens-descriptors = doJailbreak (super.proto-lens-descriptors.override {
    inherit proto-lens;
    lens-labels = self.lens-labels_0_1_0_2;
  });
  proto-lens-protoc_0_2_2_3 = appendPatch (addBuildDepend (super.proto-lens-protoc_0_2_2_3.override {
    inherit proto-lens;
    haskell-src-exts = self.haskell-src-exts_1_19_1;
  }) self.semigroups) ./patches/proto-lens-protoc-0.2.2.3.patch;
  proto-lens-protobuf-types_0_2_2_0 = doJailbreak (super.proto-lens-protobuf-types_0_2_2_0.override {
    inherit proto-lens proto-lens-protoc;
  });

  lens-labels_0_1_0_2 = doJailbreak super.lens-labels_0_1_0_2;

  haskell-src-exts_1_19_1 = appendPatch (doJailbreak super.haskell-src-exts_1_19_1) (
    # Adapt to the Semigroup–Monoid Proposal (enables building on GHC >= 8.4)
    pkgs.fetchpatch {
      url = https://github.com/haskell-suite/haskell-src-exts/commit/258e072fe9e37f94360b7488b58ea2832843bbb8.patch;
      sha256 = "0ja6ai41v9plinlhjwja282m6ahn6mw4xi79np0jxqk83cg0z1ff";
    }
  );

  tensorflow-proto = super.tensorflow-proto.override {
    inherit proto-lens proto-lens-protoc proto-lens-protobuf-types;
  };
  tensorflow = super.tensorflow.override {
    inherit mainland-pretty proto-lens;
  };
  tensorflow-core-ops = super.tensorflow-core-ops.override {
    inherit mainland-pretty proto-lens;
  };
  tensorflow-logging = super.tensorflow-logging.override {
    inherit proto-lens;
  };
  tensorflow-mnist = super.tensorflow-mnist.override {
    inherit proto-lens;
  };
  tensorflow-mnist-input-data = setSourceRoot "tensorflow-mnist-input-data" (super.callPackage (
    { mkDerivation, base, bytestring, Cabal, cryptonite, directory
    , filepath, HTTP, network-uri, stdenv
    }:
    mkDerivation {
      pname = "tensorflow-mnist-input-data";
      version = "0.1.0.0";
      src = tensorflow-haskell;
      enableSeparateDataOutput = true;
      setupHaskellDepends = [
        base bytestring Cabal cryptonite directory filepath HTTP
        network-uri
      ];
      libraryHaskellDepends = [ base ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Downloader of input data for training MNIST";
      license = stdenv.lib.licenses.asl20;
    }
  ) {});
  tensorflow-opgen = super.tensorflow-opgen.override {
    inherit mainland-pretty proto-lens;
  };
  tensorflow-ops = super.tensorflow-ops.override {
    inherit proto-lens;
  };
}
