{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.9.1";

  src = fetchurl {
    url = https://taglib.github.io/releases/taglib-1.9.1.tar.gz;
    sha256 = "06n7gnbcqa3r6c9gv00y0y1r48dyyazm6yj403i7ma0r2k6p3lvj";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  meta = {
    homepage = https://taglib.org/;
    repositories.git = git://github.com/taglib/taglib.git;
    description = "A library for reading and editing the meta-data of several popular audio formats";
    inherit (cmake.meta) platforms;
    license = with stdenv.lib.licenses; [ lgpl21 mpl11 ];
  };
}
