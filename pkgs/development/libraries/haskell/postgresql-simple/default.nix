{ cabal, aeson, attoparsec, base16Bytestring, blazeBuilder
, blazeTextual, cryptohash, HUnit, postgresqlLibpq, text, time
, transformers, uuid, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.3.9.1";
  sha256 = "0byzlmcbwlycvlk35w0gdp5x7860jcc589ypbdx0vm08aq5vz87v";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeTextual postgresqlLibpq text
    time transformers uuid vector
  ];
  testDepends = [
    base16Bytestring cryptohash HUnit text time vector
  ];
  doCheck = false;
  meta = {
    description = "Mid-Level PostgreSQL client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
