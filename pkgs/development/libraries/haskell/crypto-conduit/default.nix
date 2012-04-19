{ cabal, cereal, conduit, cryptoApi, transformers }:

cabal.mkDerivation (self: {
  pname = "crypto-conduit";
  version = "0.3.1";
  sha256 = "0hb9wkq70bmx54vksj78f0av1byvksjhqlr730cfc5fc6w60kzqk";
  buildDepends = [ cereal conduit cryptoApi transformers ];
  patchPhase = ''
    sed -i -e 's|crypto-api >= 0.9 && < 0.10|crypto-api|' crypto-conduit.cabal
  '';
  meta = {
    homepage = "https://github.com/meteficha/crypto-conduit";
    description = "Conduit interface for cryptographic operations (from crypto-api)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
