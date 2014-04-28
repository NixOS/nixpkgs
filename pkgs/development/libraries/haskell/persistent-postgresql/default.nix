{ cabal, aeson, blazeBuilder, conduit, monadControl, persistent
, postgresqlLibpq, postgresqlSimple, resourcet, text, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-postgresql";
  version = "1.3.1";
  sha256 = "19wmz9xd1jdmysr7zhlxf6z9v7pfgy0d3g7szifk8wjq8ai57lny";
  buildDepends = [
    aeson blazeBuilder conduit monadControl persistent postgresqlLibpq
    postgresqlSimple resourcet text time transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Backend for the persistent library using postgresql";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
