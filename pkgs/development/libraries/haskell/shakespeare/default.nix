{ cabal, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.0.0";
  sha256 = "16f9ynk537sra32bs5c4wncryx9sb4mfabxcjyq2mw42b8kn7ggs";
  buildDepends = [ parsec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
