{
  mkDerivation,
  aeson,
  array,
  attoparsec,
  base,
  binary,
  bytestring,
  containers,
  deepseq,
  directory,
  dlist,
  fetchFromGitHub,
  ghc-prim,
  ghcjs-prim,
  hashable,
  HUnit,
  integer-gmp,
  primitive,
  QuickCheck,
  quickcheck-unicode,
  random,
  scientific,
  test-framework,
  test-framework-hunit,
  test-framework-quickcheck2,
  text,
  time,
  transformers,
  unordered-containers,
  vector,
  lib,
}:
mkDerivation {
  pname = "ghcjs-base";
  version = "0.2.1.0";
  # This is the release 0.2.1.0, but the hackage release misses test source files,
  # so lets use github https://github.com/ghcjs/ghcjs-base/issues/132
  src = fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs-base";
    rev = "fbaae59b05b020e91783df122249095e168df53f";
    sha256 = "sha256-x6eCAK1Hne0QkV3Loi9YpxbleNHU593E4AO8cbk2vUc=";
  };
  libraryHaskellDepends = [
    aeson
    attoparsec
    base
    binary
    bytestring
    containers
    deepseq
    dlist
    ghc-prim
    ghcjs-prim
    hashable
    integer-gmp
    primitive
    scientific
    text
    time
    transformers
    unordered-containers
    vector
  ];
  testHaskellDepends = [
    array
    base
    bytestring
    deepseq
    directory
    ghc-prim
    ghcjs-prim
    HUnit
    primitive
    QuickCheck
    quickcheck-unicode
    random
    test-framework
    test-framework-hunit
    test-framework-quickcheck2
    text
  ];
  homepage = "https://github.com/ghcjs/ghcjs-base";
  description = "base library for GHCJS";
  license = lib.licenses.mit;
}
