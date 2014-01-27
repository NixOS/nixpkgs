{ cabal, attoparsec, bytedump, cryptohash, HUnit, mtl, parsec
, patience, QuickCheck, random, systemFileio, systemFilepath
, testFramework, testFrameworkQuickcheck2, time, vector, zlib
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "hit";
  version = "0.5.3";
  sha256 = "0s6nfjdasf62x28vzks809slnh0p6j3g101jzqlfh7nrnj5k6q1d";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec cryptohash mtl parsec patience random systemFileio
    systemFilepath time vector zlib zlibBindings
  ];
  testDepends = [
    bytedump HUnit QuickCheck testFramework testFrameworkQuickcheck2
    time
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hit";
    description = "Git operations in haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
