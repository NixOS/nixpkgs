{ cabal, HTTP, HUnit, network, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "oeis";
  version = "0.3.5";
  sha256 = "0r23mqbfvvvx6shzdclzfrqi8r95gxl93cih7ny7w7px3w5yc5x6";
  buildDepends = [ HTTP network ];
  testDepends = [ HUnit testFramework testFrameworkHunit ];
  meta = {
    description = "Interface to the Online Encyclopedia of Integer Sequences (OEIS)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
