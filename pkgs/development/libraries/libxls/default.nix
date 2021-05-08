{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "libxls";
  version = "1.6.2";

  src = fetchurl {
    url = "https://github.com/libxls/libxls/releases/download/v${version}/libxls-${version}.tar.gz";
    sha256 = "sha256-XazDTZS/IRWSbIDG+2nk570u1kA9Uc/0kEGpQXL143E=";
  };

  nativeBuildInputs = [ unzip ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Extract Cell Data From Excel xls files";
    homepage = "https://sourceforge.net/projects/libxls/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
