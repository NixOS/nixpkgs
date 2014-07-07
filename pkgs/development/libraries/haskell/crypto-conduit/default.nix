{ cabal, cereal, conduit, conduitExtra, cryptoApi, cryptocipher
, cryptohashCryptoapi, hspec, resourcet, skein, transformers
}:

cabal.mkDerivation (self: {
  pname = "crypto-conduit";
  version = "0.5.4";
  sha256 = "1z628gj4sf50s7pd6p41c670rz98f8b6p3n2dvl93haczcg53l1n";
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
    homepage = "https://github.com/prowdsponsor/crypto-conduit";
    description = "Conduit interface for cryptographic operations (from crypto-api)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
