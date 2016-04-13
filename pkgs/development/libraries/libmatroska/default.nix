{ stdenv, fetchurl, pkgconfig, libebml }:

stdenv.mkDerivation rec {
  name = "libmatroska-1.4.4";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libmatroska/${name}.tar.bz2";
    sha256 = "1mvb54q3gag9dj0pkwci8w75gp6mm14gi85y0ld3ar1rdngsmvyk";
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

