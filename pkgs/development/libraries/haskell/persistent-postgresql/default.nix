{ cabal, aeson, blazeBuilder, conduit, monadControl, persistent
, postgresqlLibpq, postgresqlSimple, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-postgresql";
  version = "1.2.0";
  sha256 = "0i5ha1vs91makwrw4qqwdzp92i24ynmmsmjyqpik6q80fxxiwps6";
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
