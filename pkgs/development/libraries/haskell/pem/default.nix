{ cabal, base64Bytestring, HUnit, mtl, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "pem";
  version = "0.2.0";
  sha256 = "1hmsyavqzjx1chbn4a8vf0r2wz2fg0xl9cxgja4ap04si3qr458v";
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
