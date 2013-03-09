{ cabal, cereal, cipherAes, cipherRc4, cpu, cryptoApi, cryptohash
, cryptoPubkeyTypes, entropy, primitive, QuickCheck, tagged
, testFramework, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.4.0";
  sha256 = "1qbnhzbzypin7h62sn2sibij7clsgmaiq24q3xhgbjrirb6bhqf0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal cipherAes cipherRc4 cpu cryptoApi cryptoPubkeyTypes
    primitive tagged vector
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
