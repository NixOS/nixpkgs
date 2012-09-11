{ cabal, aeson, conduit, monadControl, persistent, postgresqlLibpq
, postgresqlSimple, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-postgresql";
  version = "1.0.0";
  sha256 = "149vv6wd0a85gphwrqcyd66ivdzyy7yc37c99ngq7377fdnszzhn";
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
