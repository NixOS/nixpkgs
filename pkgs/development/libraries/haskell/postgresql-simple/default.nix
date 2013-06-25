{ cabal, attoparsec, base16Bytestring, blazeBuilder, blazeTextual
, cryptohash, HUnit, postgresqlLibpq, text, time, transformers
, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.3.3.2";
  sha256 = "1gh2ih1n6g17jry12g7nv344sfzrhfc1assslx0cjlsryhbz25lp";
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
