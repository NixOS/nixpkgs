{ cabal, byteable, cryptohash, cryptoNumbers, cryptoPubkeyTypes
, cryptoRandom, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey";
  version = "0.2.3";
  sha256 = "198gpaxlcqkp6wa5cwwnlzdxnrs7j6h7zyizczd4imwbpl0gd2mk";
  buildDepends = [
    byteable cryptohash cryptoNumbers cryptoPubkeyTypes cryptoRandom
  ];
  testDepends = [
    byteable cryptohash cryptoNumbers cryptoPubkeyTypes cryptoRandom
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-pubkey";
    description = "Public Key cryptography";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
