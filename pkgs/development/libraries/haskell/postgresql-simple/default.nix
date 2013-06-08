{ cabal, attoparsec, base16Bytestring, blazeBuilder, blazeTextual
, cryptohash, HUnit, postgresqlLibpq, text, time, transformers
, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.3.3.0";
  sha256 = "0srkalfg41gdnzwwa2bmwwrcdqnw13f7b94wv4d5a6sg6yf1ry1l";
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
