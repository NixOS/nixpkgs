{ fetchurl, stdenv, guile, guile_lib, gwrap
, pkgconfig, gconf, glib, gnome_vfs, gtk
, libglade, libgnome, libgnomecanvas, libgnomeui
, pango, guileCairo, autoconf, automake, texinfo }:

stdenv.mkDerivation rec {
  name = "guile-gnome-platform-2.16.4";

  src = fetchurl {
    url = "http://ftp.gnu.org/pub/gnu/guile-gnome/guile-gnome-platform/${name}.tar.gz";
    sha256 = "adabd48ed5993d8528fd604e0aa0d96ad81a61d06da6cdd68323572ad6c216c3";
  };

  buildInputs = [
    autoconf
    automake
    texinfo
    guile
    gwrap
    pkgconfig
    gconf
    glib
    gnome_vfs
    gtk
    libglade
    libgnome
    libgnomecanvas
    libgnomeui
    pango
    guileCairo
  ] ++ stdenv.lib.optional doCheck guile_lib;

  preConfigure = ''
      ./autogen.sh
  '';

  # The test suite tries to open an X display, which fails.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "GNOME bindings for GNU Guile";

    longDescription =
      '' GNU guile-gnome brings the power of Scheme to your graphical
         application.  guile-gnome modules support the entire Gnome library
         stack: from Pango to GnomeCanvas, Gtk+ to GStreamer, Glade to
         GtkSourceView, you will find in guile-gnome a comprehensive
         environment for developing modern applications.
      '';

    homepage = http://www.gnu.org/software/guile-gnome/;

    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ taktoa amiloradovsky ];
    platforms = with platforms; linux;
  };
}
