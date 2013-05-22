{ cabal }:

cabal.mkDerivation (self: {
  pname = "generic-deriving";
  version = "1.5.0";
  sha256 = "1m3hckwpzmarlvm2xq22za3386ady6p89kg7nd8cnjkifnnbz20r";
  meta = {
    description = "Generic programming library for generalised deriving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
