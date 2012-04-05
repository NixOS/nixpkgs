{ cabal, resourcePool, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "pool-conduit";
  version = "0.1.0";
  sha256 = "1rxagidgd18a9xk7qqafz8l3nqlbr1s4231k8bf1sxd62b8rs4sm";
  buildDepends = [ resourcePool resourcet transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Resource pool allocations via ResourceT";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
