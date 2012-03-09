{ cabal, cairo, glib, gtk2hsBuildtools, libc, mtl, pango, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "pango";
  version = "0.12.3";
  sha256 = "0203z59c9dsqp6mgb12h2iwjs52m2cqdxa7arwi1sccc3cz86cai";
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
