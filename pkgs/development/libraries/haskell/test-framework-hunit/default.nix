{ cabal, HUnit, extensibleExceptions, testFramework }:

cabal.mkDerivation (self: {
  pname = "test-framework-hunit";
  version = "0.2.6";
  sha256 = "1ivgyh71wwvrrgnk3fp6hsfssvy39jikhjdzr7x68pv1ca7f247r";
  buildDepends = [ HUnit extensibleExceptions testFramework ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "HUnit support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
