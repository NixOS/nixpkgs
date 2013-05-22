{ cabal, extensibleExceptions, HUnit, testFramework }:

cabal.mkDerivation (self: {
  pname = "test-framework-hunit";
  version = "0.3.0";
  sha256 = "1jwbpbf9q3g936gk71632h830l2wsiic8h6ms1jlmw209mpm7c84";
  buildDepends = [ extensibleExceptions HUnit testFramework ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "HUnit support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
