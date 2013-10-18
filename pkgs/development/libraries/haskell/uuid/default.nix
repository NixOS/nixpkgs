{ cabal, binary, criterion, cryptohash, deepseq, HUnit, maccatcher
, mersenneRandomPure64, QuickCheck, random, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "uuid";
  version = "1.2.14";
  sha256 = "13r2yzhb9nj1h6wfy7w9k59d27z9iza5r4apmf72zby2fi9vdnwy";
  buildDepends = [ binary cryptohash maccatcher random time ];
  testDepends = [
    criterion deepseq HUnit mersenneRandomPure64 QuickCheck random
    testFramework testFrameworkHunit testFrameworkQuickcheck2
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://projects.haskell.org/uuid/";
    description = "For creating, comparing, parsing and printing Universally Unique Identifiers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
