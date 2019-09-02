{ fetchFromGitHub }:

self: super:
let
  # https://github.com/tensorflow/haskell/pull/247
  tensorflow-haskell-src = fetchFromGitHub {
    owner = "yorickvP";
    repo = "haskell";
    rev = "0dba27f38c983de52d8160221665bbc513f7313b";
    sha256 = "1yflcwi8pxraiidjsg07flw9rdplqxr4x75sc88yd9x3zj5hwpa7";
    fetchSubmodules = true;
  };
in
/*
(echo {
  for f in tensorflow{,-core-ops,-logging,-opgen,-ops,-proto,-records{,-conduit},-test}; do
    echo $f '= super.callPackage ('
    cabal2nix . --subpath $f
    echo ') {};'
  done
echo }) | sed 's1src = ./.;1src = tensorflow-haskell-src;1' | nixfmt
*/
{
  tensorflow = super.callPackage ({ mkDerivation, async, attoparsec, base
    , bytestring, c2hs, containers, data-default, exceptions, fgl, HUnit
    , lens-family, libtensorflow, mainland-pretty, mtl, proto-lens, semigroups
    , split, stdenv, temporary, tensorflow-proto, test-framework
    , test-framework-hunit, test-framework-quickcheck2, text, transformers
    , vector }:
    mkDerivation {
      pname = "tensorflow";
      version = "0.2.0.0";
      src = tensorflow-haskell-src;
      postUnpack =
        "sourceRoot+=/tensorflow; echo source root reset to $sourceRoot";
      libraryHaskellDepends = [
        async
        attoparsec
        base
        bytestring
        containers
        data-default
        exceptions
        fgl
        lens-family
        mainland-pretty
        mtl
        proto-lens
        semigroups
        split
        temporary
        tensorflow-proto
        text
        transformers
        vector
      ];
      librarySystemDepends = [ libtensorflow ];
      libraryToolDepends = [ c2hs ];
      testHaskellDepends = [
        attoparsec
        base
        bytestring
        HUnit
        lens-family
        proto-lens
        tensorflow-proto
        test-framework
        test-framework-hunit
        test-framework-quickcheck2
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "TensorFlow bindings";
      license = stdenv.lib.licenses.asl20;
    }) { };
  tensorflow-core-ops = super.callPackage ({ mkDerivation, base, bytestring
    , Cabal, directory, filepath, lens-family, mainland-pretty, proto-lens
    , stdenv, tensorflow, tensorflow-opgen, text }:
    mkDerivation {
      pname = "tensorflow-core-ops";
      version = "0.2.0.0";
      src = tensorflow-haskell-src;
      postUnpack =
        "sourceRoot+=/tensorflow-core-ops; echo source root reset to $sourceRoot";
      setupHaskellDepends = [
        base
        bytestring
        Cabal
        directory
        filepath
        mainland-pretty
        proto-lens
        tensorflow
        tensorflow-opgen
        text
      ];
      libraryHaskellDepends =
        [ base bytestring lens-family proto-lens tensorflow text ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Haskell wrappers for Core Tensorflow Ops";
      license = stdenv.lib.licenses.asl20;
    }) { };
  tensorflow-logging = super.callPackage ({ mkDerivation, base, bytestring
    , conduit, data-default, directory, exceptions, filepath, hostname, HUnit
    , lens-family, proto-lens, resourcet, stdenv, stm, stm-chans, stm-conduit
    , temporary, tensorflow, tensorflow-core-ops, tensorflow-ops
    , tensorflow-proto, tensorflow-records-conduit, test-framework
    , test-framework-hunit, text, time, transformers }:
    mkDerivation {
      pname = "tensorflow-logging";
      version = "0.2.0.0";
      src = tensorflow-haskell-src;
      postUnpack =
        "sourceRoot+=/tensorflow-logging; echo source root reset to $sourceRoot";
      libraryHaskellDepends = [
        base
        bytestring
        conduit
        data-default
        directory
        exceptions
        filepath
        hostname
        lens-family
        proto-lens
        resourcet
        stm
        stm-chans
        stm-conduit
        tensorflow
        tensorflow-core-ops
        tensorflow-ops
        tensorflow-proto
        tensorflow-records-conduit
        text
        time
        transformers
      ];
      testHaskellDepends = [
        base
        bytestring
        conduit
        data-default
        directory
        filepath
        HUnit
        lens-family
        proto-lens
        resourcet
        temporary
        tensorflow
        tensorflow-proto
        tensorflow-records-conduit
        test-framework
        test-framework-hunit
        text
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "TensorBoard related functionality";
      license = stdenv.lib.licenses.asl20;
    }) { };
  tensorflow-opgen = super.callPackage ({ mkDerivation, base, bytestring
    , containers, filepath, lens-family, mainland-pretty, optparse-applicative
    , proto-lens, semigroups, stdenv, tensorflow-proto, text }:
    mkDerivation {
      pname = "tensorflow-opgen";
      version = "0.2.0.0";
      src = tensorflow-haskell-src;
      postUnpack =
        "sourceRoot+=/tensorflow-opgen; echo source root reset to $sourceRoot";
      libraryHaskellDepends = [
        base
        bytestring
        containers
        filepath
        lens-family
        mainland-pretty
        optparse-applicative
        proto-lens
        semigroups
        tensorflow-proto
        text
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Code generation for TensorFlow operations";
      license = stdenv.lib.licenses.asl20;
    }) { };
  tensorflow-ops = super.callPackage ({ mkDerivation, base, bytestring
    , containers, criterion, data-default, deepseq, fgl, HUnit, lens-family, mtl
    , proto-lens, QuickCheck, random, stdenv, temporary, tensorflow
    , tensorflow-core-ops, tensorflow-proto, tensorflow-test, test-framework
    , test-framework-hunit, test-framework-quickcheck2, text, transformers
    , vector }:
    mkDerivation {
      pname = "tensorflow-ops";
      version = "0.2.0.0";
      src = tensorflow-haskell-src;
      postUnpack =
        "sourceRoot+=/tensorflow-ops; echo source root reset to $sourceRoot";
      libraryHaskellDepends = [
        base
        bytestring
        containers
        data-default
        fgl
        lens-family
        mtl
        proto-lens
        tensorflow
        tensorflow-core-ops
        tensorflow-proto
        text
      ];
      testHaskellDepends = [
        base
        bytestring
        data-default
        HUnit
        lens-family
        proto-lens
        QuickCheck
        random
        temporary
        tensorflow
        tensorflow-core-ops
        tensorflow-proto
        tensorflow-test
        test-framework
        test-framework-hunit
        test-framework-quickcheck2
        transformers
        vector
      ];
      benchmarkHaskellDepends =
        [ base criterion deepseq tensorflow transformers vector ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Friendly layer around TensorFlow bindings";
      license = stdenv.lib.licenses.asl20;
    }) { };
  tensorflow-proto = super.callPackage ({ mkDerivation, base, Cabal, proto-lens
    , proto-lens-protobuf-types, proto-lens-runtime, proto-lens-setup, protobuf
    , stdenv }:
    mkDerivation {
      pname = "tensorflow-proto";
      version = "0.2.0.0";
      src = tensorflow-haskell-src;
      postUnpack =
        "sourceRoot+=/tensorflow-proto; echo source root reset to $sourceRoot";
      setupHaskellDepends = [ base Cabal proto-lens-setup ];
      libraryHaskellDepends =
        [ base proto-lens proto-lens-protobuf-types proto-lens-runtime ];
      libraryToolDepends = [ protobuf ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "TensorFlow protocol buffers";
      license = stdenv.lib.licenses.asl20;
    }) { };
  tensorflow-records = super.callPackage ({ mkDerivation, base, bytestring
    , cereal, snappy-framing, stdenv, test-framework, test-framework-quickcheck2
    }:
    mkDerivation {
      pname = "tensorflow-records";
      version = "0.1.0.0";
      src = tensorflow-haskell-src;
      postUnpack =
        "sourceRoot+=/tensorflow-records; echo source root reset to $sourceRoot";
      libraryHaskellDepends = [ base bytestring cereal snappy-framing ];
      testHaskellDepends =
        [ base bytestring cereal test-framework test-framework-quickcheck2 ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description =
        ''Encoder and decoder for the TensorFlow "TFRecords" format'';
      license = stdenv.lib.licenses.asl20;
    }) { };
  tensorflow-records-conduit = super.callPackage ({ mkDerivation, base
    , bytestring, cereal-conduit, conduit, conduit-extra, exceptions, resourcet
    , stdenv, tensorflow-records }:
    mkDerivation {
      pname = "tensorflow-records-conduit";
      version = "0.1.0.0";
      src = tensorflow-haskell-src;
      postUnpack =
        "sourceRoot+=/tensorflow-records-conduit; echo source root reset to $sourceRoot";
      libraryHaskellDepends = [
        base
        bytestring
        cereal-conduit
        conduit
        conduit-extra
        exceptions
        resourcet
        tensorflow-records
      ];
      homepage = "https://github.com/tensorflow/haskell#readme";
      description = "Conduit wrappers for TensorFlow.Records.";
      license = stdenv.lib.licenses.asl20;
    }) { };
  tensorflow-test = super.callPackage
    ({ mkDerivation, base, HUnit, stdenv, vector }:
      mkDerivation {
        pname = "tensorflow-test";
        version = "0.1.0.0";
        src = tensorflow-haskell-src;
        postUnpack =
          "sourceRoot+=/tensorflow-test; echo source root reset to $sourceRoot";
        libraryHaskellDepends = [ base HUnit vector ];
        homepage = "https://github.com/tensorflow/haskell#readme";
        description = "Some common functions for test suites";
        license = stdenv.lib.licenses.asl20;
      }) { };
}

