{ cabal, aeson, attoparsec, base16Bytestring, blazeBuilder
, blazeTextual, cryptohash, hashable, HUnit, postgresqlLibpq
, scientific, text, time, transformers, uuid, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.4.2.3";
  sha256 = "1rg6virvz4nr0m39sr72h23yks5f8ih9nimgacx30zw7xvnx942p";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeTextual hashable postgresqlLibpq
    scientific text time transformers uuid vector
  ];
  testDepends = [
    aeson base16Bytestring cryptohash HUnit text time vector
  ];
  doCheck = false;
  meta = {
    description = "Mid-Level PostgreSQL client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
