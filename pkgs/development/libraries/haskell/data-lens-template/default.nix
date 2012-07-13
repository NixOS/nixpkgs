{ cabal, dataLens }:

cabal.mkDerivation (self: {
  pname = "data-lens-template";
  version = "2.1.5";
  sha256 = "09i9lby5jd2kcg0l7y4hkga7jxixcpqw4dc7h1kngqdz92a1ydxc";
  buildDepends = [ dataLens ];
  meta = {
    homepage = "http://github.com/ekmett/data-lens-template/";
    description = "Utilities for Data.Lens";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
