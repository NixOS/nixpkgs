{ cabal, attoparsec, blazeBuilder, blazeTextual, postgresqlLibpq
, text, time, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "postgresql-simple";
  version = "0.2.4.0";
  sha256 = "1n1s650j4z82cz34rq9qgj805yc9x852snnqjaa1iwrg9i3r150f";
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
