{ stdenv, fetchurl, libebml }:

stdenv.mkDerivation rec {
  name = "libmatroska-1.0.0";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libmatroska/${name}.tar.bz2";
    sha256 = "123v2dhvv6yijqxc30spabzznjf5lbcv4iv4mmz4b3jhvwiha06w";
  };

  configurePhase = "cd make/linux";
  makeFlags = "prefix=$(out) LIBEBML_INCLUDE_DIR=${libebml}/include LIBEBML_LIB_DIR=${libebml}/lib";
  propagatedBuildInputs = [ libebml ];

  meta = {
    description = "Matroska library";
    homepage = http://dl.matroska.org/downloads/libmatroska;
  };
}

