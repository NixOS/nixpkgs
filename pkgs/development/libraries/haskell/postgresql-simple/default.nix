{ cabal, aeson, attoparsec, base16Bytestring, blazeBuilder
, blazeTextual, cryptohash, hashable, HUnit, postgresqlLibpq
, scientific, text, time, transformers, uuid, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.4.2.0";
  sha256 = "0g31a7s2h9d6f3igvrddbr357sk4vabvg88mmvb194pps66y8zzn";
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
