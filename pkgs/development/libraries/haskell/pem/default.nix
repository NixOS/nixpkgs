{ cabal, base64Bytestring, HUnit, mtl, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "pem";
  version = "0.2.1";
  sha256 = "05ln372ad89993v07q108l9al8jgjpzardpl02pziwwacdcj1j17";
  buildDepends = [ base64Bytestring mtl ];
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-pem";
    description = "Privacy Enhanced Mail (PEM) format reader and writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
