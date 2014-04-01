{ cabal, monadControl, resourcePool, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "pool-conduit";
  version = "0.1.2.2";
  sha256 = "1jg7kymr1v82xl9122q9fly385jhm1hr2406g35ydl9wnh4aaiw8";
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
