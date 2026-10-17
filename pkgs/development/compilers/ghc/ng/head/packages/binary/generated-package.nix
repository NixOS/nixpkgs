{
  mkDerivation,
  array,
  attoparsec,
  base,
  base-orphans,
  bytestring,
  Cabal,
  cereal,
  containers,
  criterion,
  deepseq,
  directory,
  fetchzip,
  filepath,
  generic-deriving,
  HUnit,
  lib,
  mtl,
  QuickCheck,
  random,
  test-framework,
  test-framework-quickcheck2,
  unordered-containers,
  zlib,
}:
mkDerivation {
  pname = "binary";
  version = "0.8.9.3";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/binary-0.8.9.3/binary-0.8.9.3.tar.gz";
    sha256 = "0dxl8kgi7vpp6k4mf2h1mgsq4k4s059d1ml8sb12rjjl9kx5vdkd";
  };
  libraryHaskellDepends = [
    array
    base
    bytestring
    containers
  ];
  testHaskellDepends = [
    array
    base
    base-orphans
    bytestring
    Cabal
    containers
    directory
    filepath
    HUnit
    QuickCheck
    random
    test-framework
    test-framework-quickcheck2
  ];
  benchmarkHaskellDepends = [
    array
    attoparsec
    base
    bytestring
    cereal
    containers
    criterion
    deepseq
    directory
    filepath
    generic-deriving
    mtl
    unordered-containers
    zlib
  ];
  homepage = "https://github.com/kolmodin/binary";
  description = "Binary serialisation for Haskell values using lazy ByteStrings";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
