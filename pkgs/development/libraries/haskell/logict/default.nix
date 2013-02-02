{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "logict";
  version = "0.6";
  sha256 = "1np4wizvwlx458kq6mmdrh8qcp1794y1bs4mnnz951h6hay5z49f";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/logict";
    description = "A backtracking logic-programming monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
