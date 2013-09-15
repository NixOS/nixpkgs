{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "boomerang";
  version = "1.4.0";
  sha256 = "1z6sx2r886jms59ah31is0fqkwix2kwxmpnrc6bb2r6xazznxfc9";
  buildDepends = [ mtl text ];
  meta = {
    description = "Library for invertible parsing and printing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
