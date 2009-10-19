{stdenv, fetchurl, gettext, perl, perlXMLParser, pkgconfig, glib, libxml2 }:

stdenv.mkDerivation {
  name = "libgpod-0.7.2";
  src = fetchurl {
    url = mirror://sourceforge/gtkpod/libgpod-0.7.2.tar.gz;
    sha256 = "0xq7947rqf99n9zvbpxfwwkid5z8d2szv5s0024rq37d6zy333rf";
  };

  buildInputs = [ gettext perl perlXMLParser pkgconfig glib libxml2 ];

  meta = {
    homepage = http://gtkpod.sourceforge.net/;
    description = "Library used by gtkpod to access the contents of an ipod";
    license = "LGPL";
  };
}
