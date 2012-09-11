{ cabal, attoparsec, blazeBuilder, blazeTextual, postgresqlLibpq
, text, time, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.2.4.1";
  sha256 = "09yszkiahfyidaq9yfk4mda5sf1m8bcqqag51vasybln9k9hhws3";
  buildDepends = [
    attoparsec blazeBuilder blazeTextual postgresqlLibpq text time
    transformers vector
  ];
  meta = {
    description = "Mid-Level PostgreSQL client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
