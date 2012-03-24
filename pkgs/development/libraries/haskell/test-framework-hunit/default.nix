{ cabal, extensibleExceptions, HUnit, testFramework }:

cabal.mkDerivation (self: {
  pname = "test-framework-hunit";
  version = "0.2.7";
  sha256 = "1c7424i5vnggzncwiwqqwq7ir7kaijif2waqmss5pn6db3gj33fc";
  buildDepends = [ extensibleExceptions HUnit testFramework ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "HUnit support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
