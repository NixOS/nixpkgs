{ cabal, cereal, cipherAes, cipherRc4, cpu, cryptoApi, cryptohash
, entropy, primitive, QuickCheck, testFramework
, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.5.0";
  sha256 = "16gqsy23y3g9089ng94124g5pvc4d0vnh2r47ii789f8j96062nd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal cipherAes cipherRc4 cpu cryptoApi primitive vector
  ];
  testDepends = [
    cryptoApi cryptohash entropy QuickCheck testFramework
    testFrameworkQuickcheck2 vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptocipher";
    description = "Symmetrical block and stream ciphers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
