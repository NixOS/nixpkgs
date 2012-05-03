{ cabal, hashable, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "vault";
  version = "0.2.0.0";
  sha256 = "1hv87kvi2bwf9ff8mhjzdf8rvqhk1xpschzs1x3swadj1kc9f1sv";
  buildDepends = [ hashable unorderedContainers ];
  meta = {
    homepage = "https://github.com/HeinrichApfelmus/vault";
    description = "a persistent store for values of arbitrary types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
