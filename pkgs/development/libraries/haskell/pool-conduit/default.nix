{ cabal, monadControl, resourcePool, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "pool-conduit";
  version = "0.1.2.1";
  sha256 = "1mcx66xv1irxd66cfv23h4n7fplg5a0hyldlgk8km0k395mjw8k8";
  buildDepends = [
    monadControl resourcePool resourcet transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Resource pool allocations via ResourceT";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
