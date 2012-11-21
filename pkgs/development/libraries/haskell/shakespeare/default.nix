{ cabal, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.0.2";
  sha256 = "1n7qymrn2f83a11zdh2950pf8rsqnc52blwi02amjxsvy2piidzm";
  buildDepends = [ parsec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
