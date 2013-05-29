{ cabal, cryptohash, cryptoNumbers, cryptoPubkeyTypes
, cryptoRandomApi, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey";
  version = "0.1.3";
  sha256 = "154bclz7mg2v7q72y6y0ylw0b28527nsmc8f6zf6ja5l9c9skw0g";
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
