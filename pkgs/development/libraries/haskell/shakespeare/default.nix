{ cabal, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.0.1.3";
  sha256 = "1m0ca3b73fiph939kpd94mxh4a606mv3hafbwg9j4is38mv5kn8d";
  buildDepends = [ parsec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
