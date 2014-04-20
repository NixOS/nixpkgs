{ cabal, attoparsec, bytedump, cryptohash, HUnit, mtl, parsec
, patience, QuickCheck, random, systemFileio, systemFilepath
, testFramework, testFrameworkQuickcheck2, time, vector, zlib
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "hit";
  version = "0.5.5";
  sha256 = "18k2fgwflzs2lpkhxg2xvni3l9cdn3hk9ajrd4flz12j7vp0ga4c";
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
