{ stdenv, fetchurl, pkgconfig, libebml }:

stdenv.mkDerivation rec {
  name = "libmatroska-1.4.7";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libmatroska/${name}.tar.bz2";
    sha256 = "1yi5cnv13nhl27xyqayd5l3sf0j3swfj3apzibv71yg9pariwi26";
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

