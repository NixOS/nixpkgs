{cabal, cairo, glib, mtl, pango, gtk2hsBuildtools, pkgconfig, gtk, glibc}:

cabal.mkDerivation (self : {
  pname = "gtk";
  version = "0.11.2";
  sha256 = "c9de86278780badbd874fb75ef01ca12a70364a9985b75f98957ba940df27aa6";
  extraBuildInputs = [pkgconfig gtk2hsBuildtools gtk glibc];
  propagatedBuildInputs = [cairo glib mtl pango];
  meta = {
    description = "Binding to the Gtk+ graphical user interface library";
    license = "LGPLv2+";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
