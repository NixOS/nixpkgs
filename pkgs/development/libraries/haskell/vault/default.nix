{ cabal, hashable, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "vault";
  version = "0.2.0.3";
  sha256 = "1ky7c5hg7spa545xhgs4ahf07w60k3x149087mla1dxl8lpcz70i";
  buildDepends = [ hashable unorderedContainers ];
  meta = {
    homepage = "https://github.com/HeinrichApfelmus/vault";
    description = "a persistent store for values of arbitrary types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
