{ stdenv, fetchurl_gnome, pkgconfig, glib, libtiff, libjpeg, libpng, xlibs
, xz, jasper }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "gdk-pixbuf";
    major = "2"; minor = "24"; patchlevel = "0"; extension = "xz";
    sha256 = "19r89nxqlpmd0ykmklz2z99dvad9svr5ndiclk7c2h84lhx1vhb7";
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
