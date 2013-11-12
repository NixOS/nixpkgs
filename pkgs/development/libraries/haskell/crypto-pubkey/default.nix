{ cabal, byteable, cryptohash, cryptoNumbers, cryptoPubkeyTypes
, cryptoRandom, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey";
  version = "0.2.2";
  sha256 = "084758n5fyh2aigd6055a75pnqjhx42sbjg36hhp2a40vhl7xr2f";
  buildDepends = [
    byteable cryptohash cryptoNumbers cryptoPubkeyTypes cryptoRandom
  ];
  testDepends = [
    byteable cryptohash cryptoNumbers cryptoRandom HUnit QuickCheck
    testFramework testFrameworkHunit testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-pubkey";
    description = "Public Key cryptography";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
