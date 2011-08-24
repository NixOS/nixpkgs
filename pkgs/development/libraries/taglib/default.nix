{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.7.0";
  
  src = fetchurl {
    url = "https://github.com/downloads/taglib/taglib/taglib-1.7.tar.gz";
    sha256 = "0gvpmfrrh4wgdpyc14zq9mk3hivp8kbmfdxjk8bi2nf3py6zpph9";
  };
  
  cmakeFlags = "-DWITH_ASF=ON -DWITH_MP4=ON";

  buildInputs = [zlib cmake];

  meta = {
    homepage = http://developer.kde.org/~wheeler/taglib.html;
    description = "A library for reading and editing the meta-data of several popular audio formats";
  };
}
