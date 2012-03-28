{ cabal }:

cabal.mkDerivation (self: {
  pname = "dlist";
  version = "0.5";
  sha256 = "1shr5wlpha68h82gwpndr5441847l01gh3j7szyvnmgzkr0fb027";
  meta = {
    homepage = "http://code.haskell.org/~dons/code/dlist/";
    description = "Differences lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
