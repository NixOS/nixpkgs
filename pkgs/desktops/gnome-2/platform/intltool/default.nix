{stdenv, fetchurl, pkgconfig, perl, perlXMLParser, gettext}:

stdenv.mkDerivation rec {
  name = "intltool-0.40.6";

  src = fetchurl {
    url = mirror://gnome/sources/intltool/0.40/intltool-0.40.6.tar.bz2;
    sha256 = "0r1vkvy5xzqk01yl6a0xlrry39bra24alkrx6279b77hc62my7jd";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ perl perlXMLParser gettext ];
}
