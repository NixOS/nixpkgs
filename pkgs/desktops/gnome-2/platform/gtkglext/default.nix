{ stdenv, fetchurl, pkgconfig, gtk, mesa, pango }:

stdenv.mkDerivation rec {
  name = "gtkglext-1.2.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkglext/1.2/${name}.tar.bz2";
    sha256 = "0lbz96jwz57hnn52b8rfj54inwpwcc9fkdq6ya043cgnfih77g8n";
  };

  buildInputs = [ pkgconfig gtk mesa pango ];

  # The library uses `GTK_WIDGET_REALIZED', `GTK_WIDGET_TOPLEVEL', and
  # `GTK_WIDGET_NO_WINDOW', all of which appear to be deprecated nowadays.
  CPPFLAGS = "-UGTK_DISABLE_DEPRECATED";

  meta = {
    homepage = http://projects.gnome.org/gtkglext/;

    description = "GtkGLExt, an OpenGL extension to GTK+";

    longDescription =
      '' GtkGLExt is an OpenGL extension to GTK+. It provides additional GDK
         objects which support OpenGL rendering in GTK+ and GtkWidget API
         add-ons to make GTK+ widgets OpenGL-capable.  In contrast to Janne
         Löf's GtkGLArea, GtkGLExt provides a GtkWidget API that enables
         OpenGL drawing for standard and custom GTK+ widgets.
      '';

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
