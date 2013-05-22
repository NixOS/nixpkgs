{ cabal }:

cabal.mkDerivation (self: {
  pname = "bitmap";
  version = "0.0.2";
  sha256 = "1flrfbrsnlcal7qyvl1wb0p8c14w0mvvkmgs7d943jqnlh4gay5m";
  meta = {
    homepage = "http://code.haskell.org/~bkomuves/";
    description = "A library for handling and manipulating bitmaps (rectangular pixel arrays)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
