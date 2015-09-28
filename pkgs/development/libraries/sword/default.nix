{ stdenv, fetchurl, pkgconfig, icu, clucene_core, curl }:

stdenv.mkDerivation rec {

  name = "sword-${version}";
  version = "1.7.4";

  src = fetchurl {
    url = "http://www.crosswire.org/ftpmirror/pub/sword/source/v1.7/${name}.tar.gz";
    sha256 = "0g91kpfkwccvdikddffdbzd6glnp1gdvkx4vh04iyz10bb7shpcr";
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
