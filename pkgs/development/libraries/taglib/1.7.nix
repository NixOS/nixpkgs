{stdenv, fetchsvn, zlib, cmake}:

stdenv.mkDerivation {
  name = "taglib-1.7a";
  
  src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport/taglib;
    rev = 1145554;
  };
  
  cmakeFlags = [ "-DWITH-ASF=ON" "-DWITH-MP4=ON" ];

  buildInputs = [ zlib cmake ];

  meta = {
    homepage = http://developer.kde.org/~wheeler/taglib.html;
    description = "A library for reading and editing the meta-data of several popular audio formats";
  };
}
