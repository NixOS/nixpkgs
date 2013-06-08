{ cabal, cryptoRandomApi, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "crypto-numbers";
  version = "0.1.3";
  sha256 = "115lgnay3ly5r53flh3v5jygqks0rg1i8qmbvrqf9nkmnmw6a5x1";
  buildDepends = [ cryptoRandomApi vector ];
  testDepends = [
    cryptoRandomApi HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-numbers";
    description = "Cryptographic numbers: functions and algorithms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
