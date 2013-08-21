{ cabal, attoparsec, base16Bytestring, blazeBuilder, blazeTextual
, cryptohash, HUnit, postgresqlLibpq, text, time, transformers
, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.3.6.0";
  sha256 = "1qszr3k7cihizbaq3naj134gavkpamk8q3g02rsilzvn0ivq8wb8";
  buildDepends = [
    attoparsec blazeBuilder blazeTextual postgresqlLibpq text time
    transformers vector
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
