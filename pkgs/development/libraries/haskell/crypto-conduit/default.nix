{ cabal, cereal, conduit, conduitExtra, cryptoApi, cryptocipher
, cryptohashCryptoapi, hspec, resourcet, skein, transformers
}:

cabal.mkDerivation (self: {
  pname = "crypto-conduit";
  version = "0.5.3";
  sha256 = "1xvjfkwd4rqlgyz172s2mihfqz1pac84qhc72c4zw1nwadsh6dgl";
  buildDepends = [
    cereal conduit conduitExtra cryptoApi resourcet transformers
  ];
  testDepends = [
    cereal conduit conduitExtra cryptoApi cryptocipher
    cryptohashCryptoapi hspec skein transformers
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
