{ cabal, attoparsec, blazeBuilder, blazeTextual, postgresqlLibpq
, text, time, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.1.4.3";
  sha256 = "0q0mkkd22hji7ns25i86shy1504d0d4mc3fqljpfffm6m36855kc";
  buildDepends = [
    attoparsec blazeBuilder blazeTextual postgresqlLibpq text time
    transformers vector
  ];
  meta = {
    description = "Mid-Level PostgreSQL client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
