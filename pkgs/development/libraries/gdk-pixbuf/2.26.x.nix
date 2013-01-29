{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng, libX11, xz, jasper }:

stdenv.mkDerivation rec {
  name = "gdk-pixbuf-2.26.5";

  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/2.26/${name}.tar.xz";
    sha256 = "112w3xl16vam72d5mj1gvs1dgr0aipbxp0qq189mmadwcg8nysbp";
  };

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 ];

  buildNativeInputs = [ pkgconfig ];

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
