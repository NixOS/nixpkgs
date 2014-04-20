{ cabal, base64Bytestring, entropy, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "scrypt";
  version = "0.5.0";
  sha256 = "1cnrjdq1ncv224dlk236a7w29na8r019d2acrsxlsaiy74iadh1y";
  buildDepends = [ base64Bytestring entropy ];
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/informatikr/scrypt";
    description = "Stronger password hashing via sequential memory-hard functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
