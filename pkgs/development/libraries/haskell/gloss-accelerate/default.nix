{ cabal, accelerate, accelerateCuda, gloss }:

cabal.mkDerivation (self: {
  pname = "gloss-accelerate";
  version = "1.8.0.0";
  sha256 = "1hcqgsdk5pjqdr2j4i5614a1r56zfxqx5nc3xpnc4yw6hssan280";
  buildDepends = [ accelerate accelerateCuda gloss ];
  meta = {
    description = "Extras to interface Gloss and Accelerate";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
