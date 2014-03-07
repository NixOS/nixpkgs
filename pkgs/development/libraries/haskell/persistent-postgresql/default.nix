{ cabal, aeson, blazeBuilder, conduit, monadControl, persistent
, postgresqlLibpq, postgresqlSimple, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-postgresql";
  version = "1.3.0.2";
  sha256 = "1d5g5zg3p0nhhkgnf9mr1wxmrpw5y1adv5lf21681an9frkisggy";
  buildDepends = [
    aeson blazeBuilder conduit monadControl persistent postgresqlLibpq
    postgresqlSimple text time transformers
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
