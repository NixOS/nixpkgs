{ cabal, hashable, nats, text, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.15.1";
  sha256 = "1vacnw598pl9acbcjjblrpdmjhmj3wz1ifrn9ki4q7yrsh4ml7mc";
  buildDepends = [ hashable nats text unorderedContainers ];
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Anything that associates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
