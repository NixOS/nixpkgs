{ cabal, dlist }:

cabal.mkDerivation (self: {
  pname = "data-default";
  version = "0.5.1";
  sha256 = "05zp9bcxm4lcdqniwckq0zi014iqcnqbrk5wh54dyy83h97z6mpv";
  buildDepends = [ dlist ];
  meta = {
    description = "A class for types with a default value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
