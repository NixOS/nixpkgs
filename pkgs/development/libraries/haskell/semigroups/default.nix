{ cabal, hashable, nats, text, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.12";
  sha256 = "0wk8hxak4dl8nbdif4f8z9gvr5bqm95inrvrcrb6ryaxichrn432";
  buildDepends = [ hashable nats text unorderedContainers ];
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Anything that associates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
