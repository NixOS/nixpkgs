{ stdenv, fetchurl, pkgconfig, icu, clucene_core, curl }:

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

  meta = with stdenv.lib; {
    description = "A software framework that allows research manipulation of Biblical texts";
    homepage = http://www.crosswire.org/sword/;
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.piotr maintainers.AndersonTorres ];
  };

}
