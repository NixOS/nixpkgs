{ cabal, HTTP, HUnit, network, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "oeis";
  version = "0.3.2";
  sha256 = "1lp4mbsh98vnyfbnq9224n98hajv8q5prpzgbcw90bih0rbiw4w4";
  buildDepends = [ HTTP network ];
  testDepends = [ HUnit testFramework testFrameworkHunit ];
  doCheck = false;
  meta = {
    description = "Interface to the Online Encyclopedia of Integer Sequences (OEIS)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
