{ cabal, aeson, conduit, monadControl, persistent, postgresqlLibpq
, postgresqlSimple, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-postgresql";
  version = "1.1.2";
  sha256 = "06ylfijm59akdzb6kd0qs5kw3qyn5ig7q9wbj0a8sgkf8hs2mmad";
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
