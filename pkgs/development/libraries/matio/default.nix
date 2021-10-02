{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "matio";
  version = "1.5.21";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${pname}-${version}.tar.gz";
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
