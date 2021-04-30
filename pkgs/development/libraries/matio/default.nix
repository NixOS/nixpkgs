{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.21";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "sha256-IYCRd+VYOefJTa2nRO5Vwd6n11fdqriWBXdtUBIvsGU=";
  };

  meta = with lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = "http://matio.sourceforge.net/";
  };
}
