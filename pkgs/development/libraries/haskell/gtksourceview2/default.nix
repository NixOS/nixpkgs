{cabal, gtk2hsBuildtools, pkgconfig, gtksourceview, glib, gtk, gtkC, glibc}:

cabal.mkDerivation (self : {
  pname = "gtksourceview2";
  version = "0.12.2";
  sha256 = "0l9y48kmzqzps6k54fgf0dkmmv0ppxx8amggfdswwk86zsf8j81r";
  extraBuildInputs = [pkgconfig gtksourceview gtkC glibc gtk2hsBuildtools];
  propagatedBuildInputs = [glib gtk];
  meta = {
    description = "GtkSourceView is a text widget that extends the standard GTK+ 2.x text widget GtkTextView";
    license = "LGPLv2+";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
