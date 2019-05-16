{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cppunit-${version}";
  version = "1.14.0";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/${name}.tar.gz";
    sha256 = "1027cyfx5gsjkdkaf6c2wnjh68882grw8n672018cj3vs9lrhmix";
  };

  meta = with stdenv.lib; {
    homepage = https://freedesktop.org/wiki/Software/cppunit/;
    description = "C++ unit testing framework";
    license = licenses.lgpl21;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
