{ cabal, conduit, resourcePool, transformers }:

cabal.mkDerivation (self: {
  pname = "pool-conduit";
  version = "0.0.0";
  sha256 = "0cbs7swb1ay3l1hlbirys171ybqg887csnp6yiy9biq11q5mhsml";
  buildDepends = [ conduit resourcePool transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Resource pool allocations via ResourceT";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
