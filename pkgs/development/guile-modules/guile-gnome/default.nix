{ fetchurl, stdenv, guile, guile_lib, gwrap
, pkgconfig, gconf, glib, gnome_vfs, gtk
, libglade, libgnome, libgnomecanvas, libgnomeui, pango, guileCairo }:

stdenv.mkDerivation rec {
  name = "guile-gnome-platform-2.16.1";

  src = fetchurl {
    url = "mirror://gnu/guile-gnome/guile-gnome-platform/${name}.tar.gz";
    sha256 = "0yy5f4c78jlakxi2bwgh3knc2szw26hg68xikyaza2iim39mc22c";
  };

  buildInputs =
    [ guile gwrap
      pkgconfig gconf glib gnome_vfs gtk libglade libgnome libgnomecanvas
      libgnomeui pango guileCairo
    ]
    ++ stdenv.lib.optional doCheck guile_lib;

  # The test suite tries to open an X display, which fails.
  doCheck = false;

  meta = {
    description = "GNOME bindings for GNU Guile";

    longDescription =
      '' GNU guile-gnome brings the power of Scheme to your graphical
         application.  guile-gnome modules support the entire Gnome library
         stack: from Pango to GnomeCanvas, Gtk+ to GStreamer, Glade to
         GtkSourceView, you will find in guile-gnome a comprehensive
         environment for developing modern applications.
      '';

    homepage = http://www.gnu.org/software/guile-gnome/;

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
