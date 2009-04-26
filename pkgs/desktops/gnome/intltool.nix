{stdenv, fetchurl, pkgconfig, perl, perlXMLParser}:

stdenv.mkDerivation rec {
  name = "intltool-0.40.6";

  src = fetchurl {
    url = "http://ftp.acc.umu.se/pub/GNOME/sources/intltool/0.40/${name}.tar.bz2";
    sha256 = "0r1vkvy5xzqk01yl6a0xlrry39bra24alkrx6279b77hc62my7jd";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ perl perlXMLParser ];
}
