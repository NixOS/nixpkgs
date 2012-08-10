{ cabal, attoparsec, blazeBuilder, blazeTextual, postgresqlLibpq
, text, time, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.2.3.0";
  sha256 = "0lbvd7mq7xqz1cala4vvw5zj96sbqi0qqnmfj5h0844ci2f25i97";
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
