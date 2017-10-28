{ fetchurl, stdenv, guile, guile-lib, gwrap
, pkgconfig, gconf, glib, gnome_vfs, gtk2
, libglade, libgnome, libgnomecanvas, libgnomeui
, pango, guile-cairo, texinfo
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "guile-gnome-platform";
  version = "2.16.4";

  src = fetchurl {
    url = "mirror://gnu/guile-gnome/${pname}/${name}.tar.gz";
    sha256 = "adabd48ed5993d8528fd604e0aa0d96ad81a61d06da6cdd68323572ad6c216c3";
  };

  buildInputs = [
    texinfo guile gwrap pkgconfig gconf glib gnome_vfs gtk2
    libglade libgnome libgnomecanvas libgnomeui pango guile-cairo
  ] ++ stdenv.lib.optional doCheck guile-lib;

  # The test suite tries to open an X display, which fails.
  doCheck = false;

  GUILE_AUTO_COMPILE = 0;

  meta = with stdenv.lib; {
    description = "GNOME bindings for GNU Guile";
    longDescription = ''
      GNU guile-gnome brings the power of Scheme to your graphical application.
      guile-gnome modules support the entire Gnome library stack: from Pango to
      GnomeCanvas, Gtk+ to GStreamer, Glade to GtkSourceView, you will find in
      guile-gnome a comprehensive environment for developing modern
      applications.
    '';
    homepage = "https://www.gnu.org/software/guile-gnome/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
