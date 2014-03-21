{ cabal, base64Bytestring, conduit, hspec, QuickCheck, transformers
}:

cabal.mkDerivation (self: {
  pname = "base64-conduit";
  version = "1.0.0.1";
  sha256 = "07zhvn3fy60q04a5g5mzhkl17rap9jlh00vb4f6565bjha2k16g9";
  buildDepends = [ base64Bytestring conduit ];
  testDepends = [
    base64Bytestring conduit hspec QuickCheck transformers
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Base64-encode and decode streams of bytes. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
