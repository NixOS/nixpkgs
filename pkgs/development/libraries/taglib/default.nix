{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.7.1";
  
  src = fetchurl {
    url = "https://github.com/downloads/taglib/taglib/${name}.tar.gz";
    sha256 = "1nc7zd9jxx5gw4n6zqgvjh0wxlm89ihcyyrzk2rbf15njw4lgpjj";
  };
  
  cmakeFlags = "-DWITH_ASF=ON -DWITH_MP4=ON";

  buildInputs = [zlib];
  nativeBuildInputs = [cmake];

  meta = {
    homepage = http://developer.kde.org/~wheeler/taglib.html;
    description = "A library for reading and editing the meta-data of several popular audio formats";
    inherit (cmake.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
