{cabal, cairo, glib, mtl, gtk2hsBuildtools, pkgconfig, pango, glibc}:

cabal.mkDerivation (self : {
  pname = "pango";
  version = "0.12.0";
  sha256 = "1vp0hl4kpgcc3xphml1hmy04hqcn12y0ks03nn32g6g33ni9mwrb";
  extraBuildInputs = [pkgconfig gtk2hsBuildtools pango glibc];
  propagatedBuildInputs = [cairo glib mtl];
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
