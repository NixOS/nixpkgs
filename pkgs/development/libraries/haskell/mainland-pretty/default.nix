{ cabal, srcloc, text }:

cabal.mkDerivation (self: {
  pname = "mainland-pretty";
  version = "0.2.1";
  sha256 = "1pl96m92bsrghkp5ixaqlhi2hybc4hafy64zlmsgjlmdvslxhs3h";
  buildDepends = [ srcloc text ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Pretty printing designed for printing source code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
