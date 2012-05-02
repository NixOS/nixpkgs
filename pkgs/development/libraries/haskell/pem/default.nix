{ cabal, attoparsec, base64Bytestring, cereal, mtl }:

cabal.mkDerivation (self: {
  pname = "pem";
  version = "0.1.1";
  sha256 = "0klb39w6mihx35xgdw5wvi1q6r61xgrsqvcqi4c5r6psv5z94cil";
  buildDepends = [ attoparsec base64Bytestring cereal mtl ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-pem";
    description = "Privacy Enhanced Mail (PEM) format reader and writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
