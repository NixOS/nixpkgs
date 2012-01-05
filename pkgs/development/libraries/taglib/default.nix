{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.7";
  
  src = fetchurl {
    url = "http://developer.kde.org/~wheeler/files/src/${name}.tar.gz";
    sha256 = "0gvpmfrrh4wgdpyc14zq9mk3hivp8kbmfdxjk8bi2nf3py6zpph9";
  };
  
  cmakeFlags = "-DWITH_ASF=ON -DWITH_MP4=ON";

  buildInputs = [zlib];
  buildNativeInputs = [cmake];

  meta = {
    homepage = http://developer.kde.org/~wheeler/taglib.html;
    description = "A library for reading and editing the meta-data of several popular audio formats";
    inherit (cmake.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
