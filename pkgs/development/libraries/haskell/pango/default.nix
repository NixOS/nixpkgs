{cabal, cairo, glib, mtl, gtk2hsBuildtools, pkgconfig, pango, glibc}:

cabal.mkDerivation (self : {
  pname = "pango";
  version = "0.12.0";
  sha256 = "1vp0hl4kpgcc3xphml1hmy04hqcn12y0ks03nn32g6g33ni9mwrb";
  extraBuildInputs = [pkgconfig gtk2hsBuildtools pango glibc];
  propagatedBuildInputs = [cairo glib mtl];
  meta = {
    description = "Binding to the Pango text rendering engine";
    license = "LGPLv2+";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
