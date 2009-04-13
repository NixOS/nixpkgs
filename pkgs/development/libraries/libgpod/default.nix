{stdenv, fetchurl, gettext, perl, perlXMLParser, pkgconfig, glib, libxml2 }:

stdenv.mkDerivation {
  name = "libgpod-0.7";
  src = fetchurl {
    url = mirror://sourceforge/gtkpod/libgpod-0.7.0.tar.gz;
    sha256 = "07jfxf4v6wd33aps9ry8kmp0k7lg1k933bag4f9vnpns3j5l63g1";
  };

  buildInputs = [ gettext perl perlXMLParser pkgconfig glib libxml2 ];
}
