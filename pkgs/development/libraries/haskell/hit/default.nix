{ cabal, attoparsec, blazeBuilder, bytedump, cryptohash, HUnit, mtl
, parsec, QuickCheck, random, systemFileio, systemFilepath
, testFramework, testFrameworkQuickcheck2, time, vector, zlib
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "hit";
  version = "0.5.0";
  sha256 = "05v49l3k8gwn922d5b5xrzdrakh6bw02bp8hd8yc8163jyazk2vx";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeBuilder cryptohash mtl parsec random systemFileio
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
