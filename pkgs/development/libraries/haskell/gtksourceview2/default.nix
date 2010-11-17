{cabal, gtk2hsBuildtools, pkgconfig, gtksourceview, glib, gtk, gtkC, glibc}:

cabal.mkDerivation (self : {
  pname = "gtksourceview2";
  version = "0.11.1";
  sha256 = "1skb13ssp6sd06jb3nshv97wjqvwa0mnzcxgmrxwd5l21r6k1m2v";
  extraBuildInputs = [pkgconfig gtksourceview gtkC glibc gtk2hsBuildtools];
  propagatedBuildInputs = [glib gtk];
  meta = {
    description = "GtkSourceView is a text widget that extends the standard GTK+ 2.x text widget GtkTextView";
    license = "LGPLv2+";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
