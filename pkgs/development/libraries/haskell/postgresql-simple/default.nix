{ cabal, aeson, attoparsec, base16Bytestring, blazeBuilder
, blazeTextual, cryptohash, HUnit, postgresqlLibpq, text, time
, transformers, uuid, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.3.10.0";
  sha256 = "1nfp05vxs3frp6yygf68ardz6s3pllccwl6myaa18kf42654lgyx";
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
