{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "taglib-1.6.1";
  
  src = fetchurl {
    url = http://developer.kde.org/~wheeler/files/src/taglib-1.6.1.tar.gz;
    sha256 = "0i5s3n6i8ac5q7gqdnynrmi75as24nhy76y0q0v764llw82jlxcf";
  };
  
  configureFlags = "--enable-asf --enable-mp4";

  buildInputs = [zlib];

  meta = {
    homepage = http://developer.kde.org/~wheeler/taglib.html;
    description = "A library for reading and editing the meta-data of several popular audio formats";
  };
}
