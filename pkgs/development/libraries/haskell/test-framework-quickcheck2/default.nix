{ cabal, QuickCheck, extensibleExceptions, testFramework }:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck2";
  version = "0.2.10";
  sha256 = "12c37m74idjydxshgms9ib9ii2rpvy4647kra2ards1w2jmnr6w3";
  buildDepends = [ QuickCheck extensibleExceptions testFramework ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "QuickCheck2 support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
