{ stdenv, fetchurl, pkgconfig, libebml }:

stdenv.mkDerivation rec {
  name = "libmatroska-1.4.5";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libmatroska/${name}.tar.bz2";
    sha256 = "1g2p2phmhkp86ldd2zqx6q0s33r7d38rsfnr4wmmdr81d6j3y0kr";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libebml ];

  meta = with stdenv.lib; {
    description = "A library to parse Matroska files";
    homepage = http://matroska.org/;
    license = licenses.lgpl21;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

