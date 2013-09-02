{ cabal, hashable, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "vault";
  version = "0.3.0.0";
  sha256 = "1lvv2sw5j48jbxniw55bxq88dhn46l7lk0blv2cnaf1vw6wms4m8";
  buildDepends = [ hashable unorderedContainers ];
  meta = {
    homepage = "https://github.com/HeinrichApfelmus/vault";
    description = "a persistent store for values of arbitrary types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
