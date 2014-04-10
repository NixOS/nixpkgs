{ cabal, aeson, attoparsec, base16Bytestring, blazeBuilder
, blazeTextual, cryptohash, hashable, HUnit, postgresqlLibpq
, scientific, text, time, transformers, uuid, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.4.2.1";
  sha256 = "1547n7rh0gsrjaa8f9lc4diljpps09kdf0gkm0cjf1gk2kr7lh94";
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
