{ cabal, HTTP, HUnit, network, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "oeis";
  version = "0.3.3";
  sha256 = "0a0h7wmyy11iqb121w4i6d8masd0xi77dnihickrhlblpbbwq0xn";
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
