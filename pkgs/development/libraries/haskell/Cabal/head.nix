{ cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck
, random, stm, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, time, zlib, fetchgit
}:

cabal.mkDerivation (self: {
  pname = "Cabal";
  version = "HEAD";
  src = fetchgit {
    url = git://github.com/haskell/cabal.git;
    rev = "699d4df12e1ec75e9100b521fb3690eaa6986635";
    sha256 = "112wz0mq7b0hvlj69imnwja2n4kv75m49yy5y8924gik9801zjba";
  };
  preConfigure = "cd Cabal";

  doCheck = false;
  noHaddock = true;

  buildDepends = [
    filepath HTTP mtl network random stm time zlib QuickCheck
  ];
  testDepends = [
    filepath HTTP HUnit mtl network QuickCheck stm testFramework
    testFrameworkHunit testFrameworkQuickcheck2 time zlib
  ];
})
