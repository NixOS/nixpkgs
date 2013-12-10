{ cabal, exceptions, hashable, stm, time, transformers, vector }:

cabal.mkDerivation (self: {
  pname = "ex-pool";
  version = "0.1.0.2";
  sha256 = "11q63yfr59r6cfzi635xj75nhcc2yi83snc75k638wyamxgvxng4";
  buildDepends = [
    exceptions hashable stm time transformers vector
  ];
  meta = {
    homepage = "https://github.com/kim/ex-pool";
    description = "Another fork of resource-pool, with a MonadIO and MonadCatch constraint";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
