{ cabal, dataLens }:

cabal.mkDerivation (self: {
  pname = "data-lens-template";
  version = "2.1.7";
  sha256 = "108xvk5glsw016vdvjb1p3a9zh7rgbkjv5xashs1hj25f8k4cw49";
  buildDepends = [ dataLens ];
  meta = {
    homepage = "http://github.com/roconnor/data-lens-template/";
    description = "Utilities for Data.Lens";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
