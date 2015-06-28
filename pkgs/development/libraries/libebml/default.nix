{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libebml-1.3.1";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libebml/${name}.tar.bz2";
    sha256 = "15a2d15rq0x9lp7rfsv0jxaw5c139xs7s5dwr5bmd9dc3arr8n0r";
  };

  meta = with stdenv.lib; {
    description = "Extensible Binary Meta Language library";
    license = licenses.lgpl21;
    homepage = http://dl.matroska.org/downloads/libebml/;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}

