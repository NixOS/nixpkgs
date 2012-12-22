{ cabal, aeson, conduit, monadControl, persistent, postgresqlLibpq
, postgresqlSimple, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-postgresql";
  version = "1.1.1";
  sha256 = "19ywyf0d7n6z8ws7s7jc958g30aiy6il43qwvqh92q1cz8bd1mj9";
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
