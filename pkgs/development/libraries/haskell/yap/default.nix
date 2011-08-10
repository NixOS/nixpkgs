{ cabal }:

cabal.mkDerivation (self: {
  pname = "yap";
  version = "0.0";
  sha256 = "0cjsmf9p220fb9yf2i81xspa3rpnlln3hfb9yc5x6xbcc6py0nw5";
  meta = {
    description = "yet another prelude - a simplistic refactoring with algebraic classes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
