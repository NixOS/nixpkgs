{ cabal, binary, criterion, cryptohash, deepseq, HUnit, maccatcher
, mersenneRandomPure64, QuickCheck, random, time
}:

cabal.mkDerivation (self: {
  pname = "uuid";
  version = "1.2.9";
  sha256 = "088wbhf21w91774icddbm3a8p8jikwjqgg8zdad0pdv8zbi7flsi";
  buildDepends = [ binary cryptohash maccatcher random time ];
  testDepends = [
    criterion deepseq HUnit mersenneRandomPure64 QuickCheck random
  ];
  meta = {
    homepage = "http://projects.haskell.org/uuid/";
    description = "For creating, comparing, parsing and printing Universally Unique Identifiers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
