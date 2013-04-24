{ cabal, cereal, conduit, cryptoApi, cryptocipher
, cryptohashCryptoapi, hspec, skein, transformers
}:

cabal.mkDerivation (self: {
  pname = "crypto-conduit";
  version = "0.5.1";
  sha256 = "04z8z7bipa40xnjr8civ1sj3df2iyvlv929ibkrdqv87gj0qv2dp";
  buildDepends = [ cereal conduit cryptoApi transformers ];
  testDepends = [
    cereal conduit cryptoApi cryptocipher cryptohashCryptoapi hspec
    skein transformers
  ];
  doCheck = false;
  patchPhase = ''
    sed -i -e 's|crypto-api >= 0.9 && < 0.12|crypto-api >= 0.9|' crypto-conduit.cabal
  '';
  meta = {
    homepage = "https://github.com/meteficha/crypto-conduit";
    description = "Conduit interface for cryptographic operations (from crypto-api)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
