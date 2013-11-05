{ stdenv, fetchurl, libebml }:

stdenv.mkDerivation rec {
  name = "libmatroska-1.4.1";

  src = fetchurl {
    url = "http://dl.matroska.org/downloads/libmatroska/${name}.tar.bz2";
    sha256 = "1dzglkl0hpimld1kahkrrp857hw5pg1r7xxbpnx7jmlj7s3j2vq8";
  };

  configurePhase = "cd make/linux";
  makeFlags = "prefix=$(out) LIBEBML_INCLUDE_DIR=${libebml}/include LIBEBML_LIB_DIR=${libebml}/lib";
  propagatedBuildInputs = [ libebml ];

  meta = {
    description = "Matroska library";
    homepage = http://dl.matroska.org/downloads/libmatroska;
  };
}

