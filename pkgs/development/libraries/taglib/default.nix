{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.6.3";
  
  src = fetchurl {
    url = "http://developer.kde.org/~wheeler/files/src/${name}.tar.gz";
    sha256 = "0jr8ixqr2q0rwcmf4n58vrwbibmd3kijsjdddck6vln6qaf0ifm9";
  };
  
  cmakeFlags = "-DWITH_ASF=ON -DWITH_MP4=ON";

  buildInputs = [zlib cmake];

  meta = {
    homepage = http://developer.kde.org/~wheeler/taglib.html;
    description = "A library for reading and editing the meta-data of several popular audio formats";
  };
}
