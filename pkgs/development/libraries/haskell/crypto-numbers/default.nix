{ cabal, byteable, cryptoRandom, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "crypto-numbers";
  version = "0.2.2";
  sha256 = "1ia39al01hb65h23ql0mr5vwzj8slv98i7a22cix8p0b6an1w3vv";
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
