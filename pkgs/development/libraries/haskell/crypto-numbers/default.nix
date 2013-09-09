{ cabal, byteable, cryptoRandom, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "crypto-numbers";
  version = "0.2.1";
  sha256 = "1bc24xk101x7npv083gzh3vjzwjh65ql85h4z0vxk3lnd0pmdmnq";
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
