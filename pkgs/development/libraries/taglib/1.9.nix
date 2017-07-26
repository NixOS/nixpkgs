{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.9.1";

  src = fetchurl {
    url = http://taglib.github.io/releases/taglib-1.9.1.tar.gz;
    sha256 = "06n7gnbcqa3r6c9gv00y0y1r48dyyazm6yj403i7ma0r2k6p3lvj";
  };

  cmakeFlags = "-DWITH_ASF=ON -DWITH_MP4=ON";

  buildInputs = [ zlib ];
  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = http://developer.kde.org/~wheeler/taglib.html;
    repositories.git = git://github.com/taglib/taglib.git;

    description = "A library for reading and editing the meta-data of several popular audio formats";
    inherit (cmake.meta) platforms;
    maintainers = [ ];
  };
}
