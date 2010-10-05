{cabal, cairo, glib, mtl, gtk2hsBuildtools, pkgconfig, pango, glibc}:

cabal.mkDerivation (self : {
  pname = "pango";
  version = "0.11.2";
  sha256 = "fb7f5dc303d3d49a330aaa3acf29560f78746edb9c67f6191756baa1b08fb504";
  extraBuildInputs = [pkgconfig gtk2hsBuildtools pango glibc];
  propagatedBuildInputs = [cairo glib mtl];
  meta = {
    description = "Binding to the Pango text rendering engine";
    license = "LGPLv2+";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
