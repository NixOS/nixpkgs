{ cabal }:

cabal.mkDerivation (self: {
  pname = "tagged";
  version = "0.6.1";
  sha256 = "1n3m1y06lhbsx9rfwwdx5xqnw4ni41b39iyysgj5894iz9rwrrnv";
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Haskell 98 phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
