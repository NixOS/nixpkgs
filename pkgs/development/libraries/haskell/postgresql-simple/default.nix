{ cabal, attoparsec, base16Bytestring, blazeBuilder, blazeTextual
, cryptohash, HUnit, postgresqlLibpq, text, time, transformers
, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.3.4.0";
  sha256 = "1xqs5hpljsapgisr7q3yd8ir351196xrdrk51dsizvk4vcs85wgs";
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
