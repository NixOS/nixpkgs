{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cppunit-1.13.2";

  src = fetchurl {
    url = http://dev-www.libreoffice.org/src/cppunit-1.13.2.tar.gz;
    sha256 = "17s2kzmkw3kfjhpp72rfppyd7syr7bdq5s69syj2nvrlwd3d4irz";
  };

  meta = {
    homepage = "http://sourceforge.net/apps/mediawiki/cppunit/";
    description = "C++ unit testing framework";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
