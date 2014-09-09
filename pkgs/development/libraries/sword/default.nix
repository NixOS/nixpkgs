{stdenv, fetchurl, pkgconfig, icu, clucene_core, curl}:

stdenv.mkDerivation rec {

  version = "1.7.3";

  name = "sword-${version}";

  src = fetchurl {
    url = "http://www.crosswire.org/ftpmirror/pub/sword/source/v1.7/${name}.tar.gz";
    sha256 = "1sm9ivypsx3mraqnziic7qkxjx1b7crvlln0zq6cnpjx2pzqfgas";
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
