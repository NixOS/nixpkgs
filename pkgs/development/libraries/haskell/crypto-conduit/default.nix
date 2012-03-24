{ cabal, cereal, conduit, cryptoApi, transformers }:

cabal.mkDerivation (self: {
  pname = "crypto-conduit";
  version = "0.1.3.1";
  sha256 = "0b8n2njz2ccdb9gql79l96jgv1nlq4ls09d25a2yy9f69w7h1ww5";
  buildDepends = [ cereal conduit cryptoApi transformers ];
  meta = {
    homepage = "https://github.com/meteficha/crypto-conduit";
    description = "Conduit interface for cryptographic operations (from crypto-api)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
