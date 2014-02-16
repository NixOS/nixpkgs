{ cabal, aeson, blazeBuilder, conduit, monadControl, persistent
, postgresqlLibpq, postgresqlSimple, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-postgresql";
  version = "1.3.0.1";
  sha256 = "00m78hdrnk367ymlgbi49p2zq2gkwskax1ng2h3ljskf3ic4jahf";
  buildDepends = [
    aeson blazeBuilder conduit monadControl persistent postgresqlLibpq
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
