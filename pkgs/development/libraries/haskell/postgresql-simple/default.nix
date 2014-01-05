{ cabal, aeson, attoparsec, base16Bytestring, blazeBuilder
, blazeTextual, cryptohash, HUnit, postgresqlLibpq, text, time
, transformers, uuid, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.4.0.1";
  sha256 = "03lj7z0n6yx55xap9606slcp0yiignwild7sibkrmg05jkb193nn";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeTextual postgresqlLibpq text
    time transformers uuid vector
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
