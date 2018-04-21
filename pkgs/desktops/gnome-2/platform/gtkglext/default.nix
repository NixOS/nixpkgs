{ stdenv, fetchurl, fetchpatch, pkgconfig, glib, gtk, libGLU_combined, pango, pangox_compat, xorg }:

stdenv.mkDerivation rec {
  name = "gtkglext-1.2.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkglext/1.2/${name}.tar.bz2";
    sha256 = "0lbz96jwz57hnn52b8rfj54inwpwcc9fkdq6ya043cgnfih77g8n";
  };

  buildInputs = with xorg;
    [ pkgconfig glib gtk libGLU_combined pango libX11 libXmu ];
  propagatedBuildInputs = [ pangox_compat ];

  patches = [
    # The library uses `GTK_WIDGET_REALIZED', `GTK_WIDGET_TOPLEVEL', and
    # `GTK_WIDGET_NO_WINDOW', all of which appear to be deprecated nowadays.
    (fetchpatch {
      name = "02_fix_gtk-2.20_deprecated_symbols.diff";
      url = https://git.gnome.org/browse/gtkglext/patch/?id=d8f285d1397f6c41099c67e668288eecc1cdae67;
      sha256 = "1zxak73plhy3m6psil1q9ssvjh9aqrif7kcbcz69y480qfb4ja08";
    })
    # Fix build with glibc ≥ 2.27
    (fetchurl {
      url = https://salsa.debian.org/gewo/gtkglext/raw/3b002677c907890c7de002c9f5b4b3ec71d11b31/debian/patches/04_glibc2.27-ftbfs.diff;
      sha256 = "1l1swkjkai6pnah23xfsfpbq2fgbhp5pzj3l0ybsx6b858cxqzj5";
    })
  ];

  meta = with stdenv.lib; {
    homepage = https://projects.gnome.org/gtkglext/;
    description = "GtkGLExt, an OpenGL extension to GTK+";
    longDescription =
      '' GtkGLExt is an OpenGL extension to GTK+. It provides additional GDK
         objects which support OpenGL rendering in GTK+ and GtkWidget API
         add-ons to make GTK+ widgets OpenGL-capable.  In contrast to Janne
         Löf's GtkGLArea, GtkGLExt provides a GtkWidget API that enables
         OpenGL drawing for standard and custom GTK+ widgets.
      '';
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
