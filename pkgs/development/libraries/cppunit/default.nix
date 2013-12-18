{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cppunit-1.12.1";

  src = fetchurl {
    url = mirror://sourceforge/cppunit/cppunit-1.12.1.tar.gz;
    sha256 = "0jm49v5rmc5qw34vqs56gy8xja1dhci73bmh23cig4kcir6a0a5c";
  };

  meta = {
    homepage = "http://sourceforge.net/apps/mediawiki/cppunit/";
    description = "C++ unit testing framework";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
