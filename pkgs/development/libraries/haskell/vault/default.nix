{ cabal, hashable, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "vault";
  version = "0.3.0.3";
  sha256 = "0wpj73jbwgcva1hfjc0bpf9l3lfc3iwdz70m29dh1785wvzxhsh5";
  buildDepends = [ hashable unorderedContainers ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/HeinrichApfelmus/vault";
    description = "a persistent store for values of arbitrary types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
