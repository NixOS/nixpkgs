{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cppunit-1.12.0";

  src = fetchurl {
    url = mirror://sourceforge/cppunit/cppunit-1.12.0.tar.gz;
    sha256 = "07zyyx5dyai94y8r8va28971f5mw84mb93xx9pm6m4ddpj6c79cq";
  };

  meta = {
    homepage = "http://sourceforge.net/apps/mediawiki/cppunit/";
    description = "C++ unit testing framework";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
