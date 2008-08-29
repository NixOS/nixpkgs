{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "taglib-1.5";
  
  src = fetchurl {
    url = http://developer.kde.org/~wheeler/files/src/taglib-1.5.tar.gz;
    sha256 = "1hhfap06zqrn17zh1cl3qlh3i598jw3qs01y2dc4i7akxhb0fqds";
  };
  
  buildInputs = [zlib];

  meta = {
    homepage = http://developer.kde.org/~wheeler/taglib.html;
    description = "A library for reading and editing the meta-data of several popular audio formats";
  };
}
