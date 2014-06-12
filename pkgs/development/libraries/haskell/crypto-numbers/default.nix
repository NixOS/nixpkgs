{ cabal, byteable, cryptoRandom, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "crypto-numbers";
  version = "0.2.3";
  sha256 = "0nx2mlf40127j7vas7liqy2yzfg4alfaxcjilcxk99kavpaanzgp";
  buildDepends = [ cryptoRandom vector ];
  testDepends = [
    byteable cryptoRandom HUnit QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2 vector
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-numbers";
    description = "Cryptographic numbers: functions and algorithms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
