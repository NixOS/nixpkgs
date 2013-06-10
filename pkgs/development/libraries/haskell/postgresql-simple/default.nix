{ cabal, attoparsec, base16Bytestring, blazeBuilder, blazeTextual
, cryptohash, HUnit, postgresqlLibpq, text, time, transformers
, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.3.3.1";
  sha256 = "0fqndncfy6yg27ndfaqyqd2q9wrbabkdq388s4q9m7maj222xlb9";
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
