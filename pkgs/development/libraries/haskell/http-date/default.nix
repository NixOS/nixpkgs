{ cabal, attoparsec }:

cabal.mkDerivation (self: {
  pname = "http-date";
  version = "0.0.1";
  sha256 = "1dqnglz1l6h14339nd5q8sq90fak64ab8fs9fkhf8ipg5y0pzwbd";
  buildDepends = [ attoparsec ];
  meta = {
    description = "HTTP Date parser/formatter";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
