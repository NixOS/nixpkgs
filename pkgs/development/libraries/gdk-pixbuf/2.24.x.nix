{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng, xlibs, xz
, jasper }:

stdenv.mkDerivation {
  name = "gdk-pixbuf-2.24.1";

  src = fetchurl {
    url = mirror://gnome/sources/gdk-pixbuf/2.24/gdk-pixbuf-2.24.1.tar.xz;
    sha256 = "1qdywh1r75lalb7z6s9pm6pmqx82chrrxqb8cdqi629nvc03yyns";
  };

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ xlibs.xlibs ];

  buildNativeInputs = [ pkgconfig xz ];

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  configureFlags = "--with-libjasper";

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "A library for image loading and manipulation";

    homepage = http://library.gnome.org/devel/gdk-pixbuf/;

    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
