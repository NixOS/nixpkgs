{ cabal, byteable, cryptohash, cryptoNumbers, cryptoPubkeyTypes
, cryptoRandom, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey";
  version = "0.2.1";
  sha256 = "06cb2h9c3r1ycgcw7scc191gbr86qi8pxil07207n5fccq3vpjys";
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
