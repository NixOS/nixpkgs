{ cabal, attoparsec, base64Bytestring, cereal, mtl }:

cabal.mkDerivation (self: {
  pname = "pem";
  version = "0.1.0";
  sha256 = "0qhkmxfhzpzg3ycdzr4b7zzf84vmhbqv2irh95ymmdbr0cc5hhn9";
  buildDepends = [ attoparsec base64Bytestring cereal mtl ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-pem";
    description = "Privacy Enhanced Mail (PEM) format reader and writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
