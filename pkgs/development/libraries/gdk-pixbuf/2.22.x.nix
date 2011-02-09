{ stdenv, fetchurl, pkgconfig, glib, libtiff, libjpeg, libpng }:

stdenv.mkDerivation rec {
  name = "gdk-pixbuf-2.22.1";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gdk-pixbuf/2.22/${name}.tar.bz2";
    sha256 = "6ce87eda24af9362307b2593c154d0b660f4e26d0abf2e71d46d0ddd55fd953d";
  };
  
  buildInputs = [ pkgconfig glib libtiff libjpeg libpng ];
  
  postInstall = "rm -rf $out/share/gtk-doc";
  
  meta = {
    description = "A library for image loading and manipulation";

    homepage = http://library.gnome.org/devel/gdk-pixbuf/;

    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
