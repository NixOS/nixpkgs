{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "logict";
  version = "0.6.0.1";
  sha256 = "0sznrnx7l5sqnyvc2xwx1q33b4833qsnhppm06a3scp9gj3y1xp2";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/logict";
    description = "A backtracking logic-programming monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
