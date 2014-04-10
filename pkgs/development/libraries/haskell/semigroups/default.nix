{ cabal, hashable, nats, text, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.13.0.1";
  sha256 = "12zd1pvggjj81hi7vm9z8fxcwsg6r2xbsg3qjs8snnybadi0qlfl";
  buildDepends = [ hashable nats text unorderedContainers ];
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Anything that associates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
