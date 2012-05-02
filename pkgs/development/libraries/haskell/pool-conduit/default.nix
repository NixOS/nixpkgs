{ cabal, resourcePool, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "pool-conduit";
  version = "0.1.0.1";
  sha256 = "1a88x8yi5p99qpq262idfzn9f5cjjdq417rbayp0kknm5c6d9n5c";
  buildDepends = [ resourcePool resourcet transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Resource pool allocations via ResourceT";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
