{ cabal, attoparsec, bytedump, cryptohash, HUnit, mtl, parsec
, patience, QuickCheck, random, systemFileio, systemFilepath
, testFramework, testFrameworkQuickcheck2, time, vector, zlib
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "hit";
  version = "0.5.4";
  sha256 = "1gr2f1bzncg8zlxk343p1ifnf2a2px000syzmr7hcf4yhhfavrhz";
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
