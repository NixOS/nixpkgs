{ cabal }:

cabal.mkDerivation (self: {
  pname = "Diff";
  version = "0.3.0";
  sha256 = "0k7fj4icnh25x21cmrnbqq0sjgxrr2ffhn8bz89qmy5h9dznvy98";
  meta = {
    description = "O(ND) diff algorithm in haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
