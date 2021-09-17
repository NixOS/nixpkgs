{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libowfat";
  version = "0.32";

  src = fetchurl {
    url = "https://www.fefe.de/libowfat/${pname}-${version}.tar.xz";
    sha256 = "1hcqg7pvy093bxx8wk7i4gvbmgnxz2grxpyy7b4mphidjbcv7fgl";
  };

  makeFlags = [ "prefix=$(out)" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "A GPL reimplementation of libdjb";
    homepage = "https://www.fefe.de/libowfat/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
