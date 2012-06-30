{ stdenv, fetchurl, libebml }:

stdenv.mkDerivation rec {
  name = "libmatroska-1.3.0";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libmatroska/${name}.tar.bz2";
    sha256 = "0scfs5lc1nvdfv7ipgg02h7wzxks48hc5lvgk9qmwdkihnayqcaj";
  };

  configurePhase = "cd make/linux";
  makeFlags = "prefix=$(out) LIBEBML_INCLUDE_DIR=${libebml}/include LIBEBML_LIB_DIR=${libebml}/lib";
  propagatedBuildInputs = [ libebml ];

  meta = {
    description = "Matroska library";
    homepage = http://dl.matroska.org/downloads/libmatroska;
  };
}

