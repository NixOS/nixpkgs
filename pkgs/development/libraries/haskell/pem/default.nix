{ cabal, attoparsec, base64Bytestring, cereal, mtl }:

cabal.mkDerivation (self: {
  pname = "pem";
  version = "0.1.2";
  sha256 = "1p2sw36b9w6lf53jzj86ibyy9a48fjd786mx3x8mvc5lczx8v78m";
  buildDepends = [ attoparsec base64Bytestring cereal mtl ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-pem";
    description = "Privacy Enhanced Mail (PEM) format reader and writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
