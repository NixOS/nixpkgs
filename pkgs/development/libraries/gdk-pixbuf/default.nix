{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng, libX11, xz
, jasper }:

stdenv.mkDerivation rec {
  name = "gdk-pixbuf-2.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/2.28/${name}.tar.xz";
    sha256 = "0iykaw95xp5pids16nz7xqh26nzhwsigrcw8jma0f6zvbdlkf7jn";
  };

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  configureFlags = "--with-libjasper --with-x11";

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "A library for image loading and manipulation";

    homepage = http://library.gnome.org/devel/gdk-pixbuf/;

    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
