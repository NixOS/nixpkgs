{ cabal, attoparsec, blazeBuilder, blazeTextual, postgresqlLibpq
, text, time, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.2.2.0";
  sha256 = "1saxdvnhjxa9faxzi9sylg2jxpdhzf6p461mas7xvl02m24dfwpc";
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
