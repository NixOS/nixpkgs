{ cabal, aeson, conduit, monadControl, persistent, postgresqlLibpq
, postgresqlSimple, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-postgresql";
  version = "1.1.2.1";
  sha256 = "1iz6w9isva1drbr37c8f42g3nnl78sp27ydaj0975yqyp7nh7and";
  buildDepends = [
    aeson conduit monadControl persistent postgresqlLibpq
    postgresqlSimple text time transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Backend for the persistent library using postgresql";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
