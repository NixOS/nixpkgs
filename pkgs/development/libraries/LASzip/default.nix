{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  version = "2.2.0";
  name = "laszip-${version}";

  src = fetchurl {

    url = "https://github.com/LASzip/LASzip/archive/v${version}.tar.gz";
    md5 = "5b8a7c713bd79e0d1d7f7cc8fe9e59bb";
  };
  
  buildInputs = [cmake];

  meta = {

    description = "LASzip  quickly turns bulky LAS files into compact LAZ files without information loss";
    homepage = http://www.laszip.org;
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
