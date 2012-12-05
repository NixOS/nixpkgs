{ cabal, extensibleExceptions, QuickCheck, random, testFramework }:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck2";
  version = "0.3.0";
  sha256 = "18bha70sc40z7ll4l3bazzqk4z5kgcxnnzriz1qa3yv4xyqaaz0i";
  buildDepends = [
    extensibleExceptions QuickCheck random testFramework
  ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "QuickCheck2 support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
