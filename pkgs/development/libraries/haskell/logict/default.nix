{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "logict";
  version = "0.6.0.2";
  sha256 = "07hnirv6snnym2r7iijlfz00b60jpy2856zvqxh989q0in7bd0hi";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/";
    description = "A backtracking logic-programming monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
