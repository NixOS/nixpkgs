{ cabal, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "0.11";
  sha256 = "0ksjgl2x97n5ci346vlmc2kd8plvsg6kn5cncbxkd8c6w4h28a4b";
  buildDepends = [ parsec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
