{cabal, cairo, glib, gtk, mtl, pango, gtk2hsBuildtools, pkgconfig, gnome, glibc}:

cabal.mkDerivation (self : {
  pname = "glade";
  version = "0.11.1";
  sha256 = "0d96a8576f89a81aa1ecdaf172e42e9eb1e7b40ce1b23cff36ab473165832c6a";
  extraBuildInputs = [pkgconfig gtk2hsBuildtools gnome.libglade gnome.gtk glibc];
  propagatedBuildInputs = [cairo glib gtk mtl pango];
  meta = {
    description = "Binding to the glade library";
    license = "LGPLv2+";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
