{ cabal, byteable, cryptoRandom, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "crypto-numbers";
  version = "0.2.0";
  sha256 = "1s4q9qqb7qb0shaxmhhxixsnhgwn2h6nxxblkfqqqvkdiwis278j";
  buildDepends = [ cryptoRandom vector ];
  testDepends = [
    byteable cryptoRandom HUnit QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2 vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-numbers";
    description = "Cryptographic numbers: functions and algorithms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
