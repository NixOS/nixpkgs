{ cabal, resourcePool, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "pool-conduit";
  version = "0.1.0.3";
  sha256 = "0q95b4770xfd9ancbzbisslqax3pcvg1yf3kkplnvp335ffxbax9";
  buildDepends = [ resourcePool resourcet transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Resource pool allocations via ResourceT";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
