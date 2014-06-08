{ cabal, hashable, nats, text, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.14";
  sha256 = "07jmfb3h4kz3a2ysrkhzzpfdhxglszq6qqsmg2011f0hdzm24ay7";
  buildDepends = [ hashable nats text unorderedContainers ];
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Anything that associates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
