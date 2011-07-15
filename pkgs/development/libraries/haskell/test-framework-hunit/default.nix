{cabal, HUnit, testFramework}:

cabal.mkDerivation (self : {
  pname = "test-framework-hunit";
  version = "0.2.6";
  sha256 = "1ivgyh71wwvrrgnk3fp6hsfssvy39jikhjdzr7x68pv1ca7f247r";
  propagatedBuildInputs = [HUnit testFramework];
  meta = {
    description = "HUnit support for the test-framework package";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

