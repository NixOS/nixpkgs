{ cabal, attoparsec }:

cabal.mkDerivation (self: {
  pname = "http-date";
  version = "0.0.0";
  sha256 = "0jia05636xk9k70hqjjiny5298pkb8g7mck7zybfwvigi1fppa46";
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
