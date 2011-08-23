{ cabal, cairo, glib, glibc, gtk2hsBuildtools, mtl, pango
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "pango";
  version = "0.12.0";
  sha256 = "1vp0hl4kpgcc3xphml1hmy04hqcn12y0ks03nn32g6g33ni9mwrb";
  buildDepends = [ cairo glib mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ glibc pkgconfig ];
  pkgconfigDepends = [ cairo pango ];
  meta = {
    homepage = "http://www.haskell.org/gtk2hs/";
    description = "Binding to the Pango text rendering engine";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
