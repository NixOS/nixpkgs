{ cabal, cairo, glib, gtk2hsBuildtools, libc, mtl, pango, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "pango";
  version = "0.12.1";
  sha256 = "0bfwgz2wx0hw9lrf9fdc0pic7xjkiqnv1wr1lfp55gm2qhakz83w";
  buildDepends = [ cairo glib mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ cairo pango ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the Pango text rendering engine";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
