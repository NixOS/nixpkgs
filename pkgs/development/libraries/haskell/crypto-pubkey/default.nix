{ cabal, cryptohash, cryptoNumbers, cryptoPubkeyTypes
, cryptoRandomApi, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey";
  version = "0.1.4";
  sha256 = "13ah3ip6gdv7b1zz5qwi7515a3k8pp3l0jr1kq4q2a0vqy24gkn1";
  buildDepends = [
    cryptohash cryptoNumbers cryptoPubkeyTypes cryptoRandomApi
  ];
  testDepends = [
    cryptohash cryptoNumbers cryptoRandomApi HUnit QuickCheck
    testFramework testFrameworkHunit testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-pubkey";
    description = "Public Key cryptography";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
