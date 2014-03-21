{ cabal }:

cabal.mkDerivation (self: {
  pname = "tagged";
  version = "0.7.1";
  sha256 = "036k5k44971fq6zdxc36kkic9ma93mcas7zk48i32s60iznnfc6v";
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Haskell 98 phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
