{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng, libX11, xz
, jasper, libintlOrEmpty, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gdk-pixbuf-2.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/2.28/${name}.tar.xz";
    sha256 = "1fy2a05xhfg7gy4l4aajsbmgj62zxhikdxqh6bicihxmzm1vg85y";
  };

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ gobjectIntrospection libX11 libintlOrEmpty];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  configureFlags = "--with-libjasper --with-x11 --enable-introspection";

  postInstall = "rm -rf $out/share/gtk-doc";

  passthru = {
    gir_path = "/share/gir-1.0";
    gi_typelib_path = "/lib/girepository-1.0";
  };

  meta = {
    description = "A library for image loading and manipulation";

    homepage = http://library.gnome.org/devel/gdk-pixbuf/;

    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
