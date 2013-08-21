{ cabal, cereal, cipherAes, cipherRc4, cpu, cryptoApi, cryptohash
, entropy, primitive, QuickCheck, testFramework
, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.5.1";
  sha256 = "118sabi90qjyqbvfincn737c4mi9mvjij1dzx7k9rsgad47p0753";
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
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Symmetrical block and stream ciphers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
