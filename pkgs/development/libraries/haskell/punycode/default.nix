{ cabal, cereal, encoding, HUnit, mtl, QuickCheck, text }:

cabal.mkDerivation (self: {
  pname = "punycode";
  version = "2.0";
  sha256 = "192jgfixnpxdj6jiiz92kx5bi6ij3c389b76q9f4vyfmvcajj1sr";
  buildDepends = [ cereal mtl text ];
  testDepends = [ cereal encoding HUnit mtl QuickCheck text ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/litherum/punycode";
    description = "Encode unicode strings to ascii forms according to RFC 3492";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
