{ cabal, hashable, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "vault";
  version = "0.2.0.4";
  sha256 = "1a63rarksp4waj64b9kv8q77wbhdnsnxahkixl1klp25hkp8aan3";
  buildDepends = [ hashable unorderedContainers ];
  meta = {
    homepage = "https://github.com/HeinrichApfelmus/vault";
    description = "a persistent store for values of arbitrary types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
