{ pkgs, haskellLib }:

with haskellLib;

self: super:
let
  tensorflow-haskell = pkgs.fetchFromGitHub {
    owner = "tensorflow";
    repo = "haskell";
    rev = "e40d2c44f0a861701cc90ec73c2bcee669ab5ba7";
    sha256 = "05pda34jfrlqmb8y9l8g87n4iq87v1z820vnd3cy41v5c5nrdpa8";
    fetchSubmodules = true;
  };

  setSourceRoot = dir: drv: drv.overrideAttrs (_oldAttrs: {sourceRoot = "source/${dir}";});

  proto-lens = self.proto-lens_0_2_2_0;
  proto-lens-protoc = self.proto-lens-protoc_0_2_2_3;
  proto-lens-protobuf-types = self.proto-lens-protobuf-types_0_2_2_0;
  mainland-pretty = self.mainland-pretty_0_6_2;
  lens-labels = self.lens-labels_0_1_0_2;
  haskell-src-exts = self.haskell-src-exts_1_19_1;
in
{
  proto-lens-descriptors = super.proto-lens-descriptors.override {
    inherit proto-lens lens-labels;
  };
  proto-lens-protoc_0_2_2_3 = super.proto-lens-protoc_0_2_2_3.override {
    inherit proto-lens haskell-src-exts;
  };
  proto-lens-protobuf-types_0_2_2_0 = super.proto-lens-protobuf-types_0_2_2_0.override {
    inherit proto-lens proto-lens-protoc;
  };
  tensorflow-proto = setSourceRoot "tensorflow-proto" (super.callPackage (
    { mkDerivation, base, Cabal, proto-lens, proto-lens-protobuf-types
    , proto-lens-protoc, stdenv
    }:
    mkDerivation {
      pname = "tensorflow-proto";
      version = "0.1.0.0";
      src = tensorflow-haskell;
      setupHaskellDepends = [ base Cabal proto-lens-protoc ];
      libraryHaskellDepends = [
        base proto-lens proto-lens-protobuf-types proto-lens-protoc
      ];
      libraryToolDepends = [ pkgs.protobuf ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "TensorFlow protocol buffers";
      license = stdenv.lib.licenses.asl20;
    }
  ) {
    inherit proto-lens proto-lens-protoc proto-lens-protobuf-types;
  });
  tensorflow = setSourceRoot "tensorflow" (super.callPackage (
    { mkDerivation, async, attoparsec, base, bytestring, c2hs
    , containers, data-default, exceptions, fgl, HUnit, lens-family
    , mainland-pretty, mtl, proto-lens, semigroups, split, stdenv
    , temporary, libtensorflow, tensorflow-proto, test-framework
    , test-framework-hunit, test-framework-quickcheck2, text
    , transformers, vector
    }:
    mkDerivation {
      pname = "tensorflow";
      version = "0.1.0.2";
      src = tensorflow-haskell;
      libraryHaskellDepends = [
        async attoparsec base bytestring containers data-default exceptions
        fgl lens-family mainland-pretty mtl proto-lens semigroups split
        temporary tensorflow-proto text transformers vector
      ];
      librarySystemDepends = [ libtensorflow ];
      libraryToolDepends = [ c2hs ];
      testHaskellDepends = [
        attoparsec base bytestring HUnit lens-family proto-lens
        tensorflow-proto test-framework test-framework-hunit
        test-framework-quickcheck2
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "TensorFlow bindings";
      license = stdenv.lib.licenses.asl20;
    }
  ) {
    inherit mainland-pretty proto-lens;
  });
  tensorflow-core-ops = setSourceRoot "tensorflow-core-ops" (super.callPackage (
    { mkDerivation, base, bytestring, Cabal, directory, filepath
    , lens-family, mainland-pretty, proto-lens, stdenv, tensorflow
    , tensorflow-opgen, text
    }:
    mkDerivation {
      pname = "tensorflow-core-ops";
      version = "0.1.0.0";
      src = tensorflow-haskell;
      setupHaskellDepends = [
        base bytestring Cabal directory filepath mainland-pretty proto-lens
        tensorflow tensorflow-opgen text
      ];
      libraryHaskellDepends = [
        base bytestring lens-family proto-lens tensorflow text
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Haskell wrappers for Core Tensorflow Ops";
      license = stdenv.lib.licenses.asl20;
    }
  ) {
    inherit mainland-pretty proto-lens;
  });
  tensorflow-logging = setSourceRoot "tensorflow-logging" (super.callPackage (
    { mkDerivation, base, bytestring, conduit, data-default, directory
    , exceptions, filepath, hostname, HUnit, lens-family, proto-lens
    , resourcet, stdenv, stm, stm-chans, stm-conduit, temporary
    , tensorflow, tensorflow-core-ops, tensorflow-ops, tensorflow-proto
    , tensorflow-records-conduit, test-framework, test-framework-hunit
    , text, time, transformers
    }:
    mkDerivation {
      pname = "tensorflow-logging";
      version = "0.1.0.0";
      src = tensorflow-haskell;
      libraryHaskellDepends = [
        base bytestring conduit data-default directory exceptions filepath
        hostname lens-family proto-lens resourcet stm stm-chans stm-conduit
        tensorflow tensorflow-core-ops tensorflow-ops tensorflow-proto
        tensorflow-records-conduit text time transformers
      ];
      testHaskellDepends = [
        base bytestring conduit data-default directory filepath HUnit
        lens-family proto-lens resourcet temporary tensorflow
        tensorflow-proto tensorflow-records-conduit test-framework
        test-framework-hunit text
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "TensorBoard related functionality";
      license = stdenv.lib.licenses.asl20;
    }
  ) {
    inherit proto-lens;
  });
  tensorflow-mnist = setSourceRoot "tensorflow-mnist" (super.callPackage (
    { mkDerivation, base, binary, bytestring, containers, filepath
    , HUnit, lens-family, proto-lens, split, stdenv, tensorflow
    , tensorflow-core-ops, tensorflow-mnist-input-data, tensorflow-ops
    , tensorflow-proto, test-framework, test-framework-hunit, text
    , transformers, vector, zlib
    }:
    mkDerivation {
      pname = "tensorflow-mnist";
      version = "0.1.0.0";
      src = tensorflow-haskell;
      isLibrary = true;
      isExecutable = true;
      enableSeparateDataOutput = true;
      libraryHaskellDepends = [
        base binary bytestring containers filepath lens-family proto-lens
        split tensorflow tensorflow-core-ops tensorflow-proto text vector
        zlib
      ];
      executableHaskellDepends = [
        base bytestring filepath lens-family proto-lens tensorflow
        tensorflow-mnist-input-data tensorflow-ops tensorflow-proto text
        transformers vector
      ];
      testHaskellDepends = [
        base bytestring HUnit lens-family proto-lens tensorflow
        tensorflow-mnist-input-data tensorflow-ops tensorflow-proto
        test-framework test-framework-hunit text transformers vector
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "TensorFlow demo application for learning MNIST model";
      license = stdenv.lib.licenses.asl20;
    }
  ) {
    inherit proto-lens;
  });
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
  tensorflow-opgen = setSourceRoot "tensorflow-opgen" (super.callPackage (
    { mkDerivation, base, bytestring, containers, filepath, lens-family
    , mainland-pretty, optparse-applicative, proto-lens, semigroups
    , stdenv, tensorflow-proto, text
    }:
    mkDerivation {
      pname = "tensorflow-opgen";
      version = "0.1.0.0";
      src = tensorflow-haskell;
      libraryHaskellDepends = [
        base bytestring containers filepath lens-family mainland-pretty
        optparse-applicative proto-lens semigroups tensorflow-proto text
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Code generation for TensorFlow operations";
      license = stdenv.lib.licenses.asl20;
    }
  ) {
    inherit mainland-pretty proto-lens;
  });
  tensorflow-ops = setSourceRoot "tensorflow-ops" (super.callPackage (
    { mkDerivation, base, bytestring, containers, criterion
    , data-default, deepseq, fgl, HUnit, lens-family, mtl, proto-lens
    , QuickCheck, random, stdenv, temporary, tensorflow
    , tensorflow-core-ops, tensorflow-proto, tensorflow-test
    , test-framework, test-framework-hunit, test-framework-quickcheck2
    , text, transformers, vector
    }:
    mkDerivation {
      pname = "tensorflow-ops";
      version = "0.1.0.0";
      src = tensorflow-haskell;
      libraryHaskellDepends = [
        base bytestring containers data-default fgl lens-family mtl
        proto-lens tensorflow tensorflow-core-ops tensorflow-proto text
      ];
      testHaskellDepends = [
        base bytestring data-default HUnit lens-family proto-lens
        QuickCheck random temporary tensorflow tensorflow-core-ops
        tensorflow-proto tensorflow-test test-framework
        test-framework-hunit test-framework-quickcheck2 transformers vector
      ];
      benchmarkHaskellDepends = [
        base criterion deepseq tensorflow transformers vector
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Friendly layer around TensorFlow bindings";
      license = stdenv.lib.licenses.asl20;
    }
  ) {
    inherit proto-lens;
  });
  tensorflow-records = setSourceRoot "tensorflow-records" (super.callPackage (
    { mkDerivation, base, bytestring, cereal, snappy-framing, stdenv
    , test-framework, test-framework-quickcheck2
    }:
    mkDerivation {
      pname = "tensorflow-records";
      version = "0.1.0.0";
      src = tensorflow-haskell;
      libraryHaskellDepends = [ base bytestring cereal snappy-framing ];
      testHaskellDepends = [
        base bytestring cereal test-framework test-framework-quickcheck2
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Encoder and decoder for the TensorFlow \"TFRecords\" format";
      license = stdenv.lib.licenses.asl20;
    }
  ) {});
  tensorflow-records-conduit = setSourceRoot "tensorflow-records-conduit" (super.callPackage (
    { mkDerivation, base, bytestring, cereal-conduit, conduit
    , conduit-extra, exceptions, resourcet, stdenv, tensorflow-records
    }:
    mkDerivation {
      pname = "tensorflow-records-conduit";
      version = "0.1.0.0";
      src = tensorflow-haskell;
      libraryHaskellDepends = [
        base bytestring cereal-conduit conduit conduit-extra exceptions
        resourcet tensorflow-records
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Conduit wrappers for TensorFlow.Records.";
      license = stdenv.lib.licenses.asl20;
    }
  ) {});
  tensorflow-test = setSourceRoot "tensorflow-test" (super.callPackage (
    { mkDerivation, base, HUnit, stdenv, vector }:
    mkDerivation {
      pname = "tensorflow-test";
      version = "0.1.0.0";
      src = tensorflow-haskell;
      libraryHaskellDepends = [ base HUnit vector ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Some common functions for test suites";
      license = stdenv.lib.licenses.asl20;
    }
  ) {});
}
