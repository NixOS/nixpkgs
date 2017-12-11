{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.11.1";

  src = fetchurl {
    url = "http://taglib.org/releases/${name}.tar.gz";
    sha256 = "0ssjcdjv4qf9liph5ry1kngam1y7zp8fzr9xv4wzzrma22kabldn";
  };

  cmakeFlags = "-DWITH_ASF=ON -DWITH_MP4=ON";

  buildInputs = [ zlib ];
  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = http://taglib.org/;
    repositories.git = git://github.com/taglib/taglib.git;

    description = "A library for reading and editing the meta-data of several popular audio formats";
    inherit (cmake.meta) platforms;
    maintainers = [ ];
  };
}
