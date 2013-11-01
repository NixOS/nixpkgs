{ cabal, extensibleExceptions, HUnit, testFramework }:

cabal.mkDerivation (self: {
  pname = "test-framework-hunit";
  version = "0.3.0.1";
  sha256 = "1h0h55kf6ff25nbfx1mhliwyknc0glwv3zi78wpzllbjbs7gvyfk";
  buildDepends = [ extensibleExceptions HUnit testFramework ];
  meta = {
    homepage = "https://batterseapower.github.io/test-framework/";
    description = "HUnit support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
