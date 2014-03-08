{ cabal, asn1Encoding, asn1Parse, asn1Types, cryptohash
, cryptoPubkeyTypes, filepath, HUnit, mtl, pem, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "x509";
  version = "1.4.10";
  sha256 = "1xsq0g7f5ki6l9yx604j6bsl1k7s3p1xr6hh2086hsgl9fp1f9ap";
  buildDepends = [
    asn1Encoding asn1Parse asn1Types cryptohash cryptoPubkeyTypes
    filepath mtl pem time
  ];
  testDepends = [
    asn1Types cryptoPubkeyTypes HUnit mtl QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2 time
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-certificate";
    description = "X509 reader and writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
