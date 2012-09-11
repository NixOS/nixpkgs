{ cabal, hashable, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "vault";
  version = "0.2.0.1";
  sha256 = "027wgbnmdnp98f0wvc9xsfh175n7rq8m2j9i7j1c5vxwgi61dqxq";
  buildDepends = [ hashable unorderedContainers ];
  meta = {
    homepage = "https://github.com/HeinrichApfelmus/vault";
    description = "a persistent store for values of arbitrary types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
