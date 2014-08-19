{stdenv, fetchurl, pkgconfig, icu, clucene_core, curl}:

stdenv.mkDerivation rec {

  version = "1.7.2";

  name = "sword-${version}";

  src = fetchurl {
    url = "http://www.crosswire.org/ftpmirror/pub/sword/source/v1.7/${name}.tar.gz";
    sha256 = "ac7aace0ecb7a405d4b4b211ee1ae5b2250bb5c57c9197179747c9e830787871";
  };

  buildInputs = [ pkgconfig icu clucene_core curl ];

  prePatch = ''
    patchShebangs .;
  '';

  configureFlags = "--without-conf --enable-tests=no CXXFLAGS=-Wno-unused-but-set-variable";

  meta = {
    description = "A software framework that allows research manipulation of Biblical texts";
    homepage = http://www.crosswire.org/sword/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.piotr stdenv.lib.maintainers.AndersonTorres ];
  };

}
