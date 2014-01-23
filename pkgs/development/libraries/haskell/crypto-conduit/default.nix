{ cabal, cereal, conduit, cryptoApi, cryptocipher
, cryptohashCryptoapi, hspec, skein, transformers
}:

cabal.mkDerivation (self: {
  pname = "crypto-conduit";
  version = "0.5.2.2";
  sha256 = "1969jys4za3m818jvnfcsv5hpc50bcvkrmy9lxr8fz854q01vhk2";
  buildDepends = [ cereal conduit cryptoApi transformers ];
  testDepends = [
    cereal conduit cryptoApi cryptocipher cryptohashCryptoapi hspec
    skein transformers
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/meteficha/crypto-conduit";
    description = "Conduit interface for cryptographic operations (from crypto-api)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
