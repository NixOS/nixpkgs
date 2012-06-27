{ cabal, resourcePool, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "pool-conduit";
  version = "0.1.0.2";
  sha256 = "1fs2kskvsvck9n011f2pv0s3mxd2hh71p61dxrskz79mfvks5yky";
  buildDepends = [ resourcePool resourcet transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Resource pool allocations via ResourceT";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
