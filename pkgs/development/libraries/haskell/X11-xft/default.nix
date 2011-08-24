{ ghc, cabal, X11, utf8String, pkgconfig, libXft, freetype, fontconfig }:
cabal.mkDerivation (self : {
  pname = "X11-xft";
  version = "0.3";
  sha256 = "48892d0d0a90d5b47658877facabf277bf8466b7388eaf6ce163b843432a567d";
  buildInputs = [ ghc pkgconfig libXft freetype fontconfig ];
  propagatedBuildInputs = [ X11 utf8String ];
  configureFlags=["--extra-include-dirs=${freetype}/include/freetype2"];
  meta = {
    description = "Bindings to the Xft, X Free Type interface library, and some Xrender parts";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
