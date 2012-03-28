{ cabal }:

cabal.mkDerivation (self: {
  pname = "deepseq";
  version = "1.3.0.0";
  sha256 = "0z2k1rda67nmhv62irjfd642iarj1i9m55l6p47j4cysrszhvqgy";
  meta = {
    description = "Deep evaluation of data structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
