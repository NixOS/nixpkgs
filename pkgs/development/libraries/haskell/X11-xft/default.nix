{ cabal, fontconfig, freetype, libXft, pkgconfig, utf8String, X11
}:

cabal.mkDerivation (self: {
  pname = "X11-xft";
  version = "0.3.1";
  sha256 = "1lgqb0s2qfwwgbvwxhjbi23rbwamzdi0l0slfr20c3jpcbp3zfjf";
  buildDepends = [ utf8String X11 ];
  extraLibraries = [ fontconfig freetype pkgconfig ];
  pkgconfigDepends = [ libXft ];
  configureFlags = "--extra-include-dirs=${freetype}/include/freetype2";
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
