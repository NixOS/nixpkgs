{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng, libX11, xz, jasper }:

stdenv.mkDerivation rec {
  name = "gdk-pixbuf-2.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/2.26/${name}.tar.xz";
    sha256 = "a60af12b58d9cc15ba4c680c6730ce5d38e8d664af1d575a379385b94b4ec7ba";
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
