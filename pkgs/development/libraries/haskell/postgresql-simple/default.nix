{ cabal, aeson, attoparsec, base16Bytestring, blazeBuilder
, blazeTextual, cryptohash, HUnit, postgresqlLibpq, text, time
, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.3.8.0";
  sha256 = "1p1cxp7mjrxyxxqrq2skm3kqrnmb3k6fb8kwr2aj9cnbqfhwl1qf";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeTextual postgresqlLibpq text
    time transformers vector
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
