{ cabal, attoparsec, bytedump, cryptohash, hourglass, HUnit, mtl
, parsec, patience, QuickCheck, random, systemFileio
, systemFilepath, testFramework, testFrameworkQuickcheck2, vector
, zlib, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "hit";
  version = "0.6.0";
  sha256 = "1haslqhnpfdll5cl3vq1y03h916lydhc9mq4gagm9qzjfjqv54k2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec cryptohash hourglass mtl parsec patience random
    systemFileio systemFilepath vector zlib zlibBindings
  ];
  testDepends = [
    bytedump hourglass HUnit QuickCheck testFramework
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hit";
    description = "Git operations in haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
