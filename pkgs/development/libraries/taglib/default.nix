{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.11";

  src = fetchurl {
    url = "http://taglib.github.io/releases/${name}.tar.gz";
    sha256 = "1272xj07ky86prnm8qzw8izk9i2ln3172032n8q9mzvhv6rsnk7d";
  };

  cmakeFlags = "-DWITH_ASF=ON -DWITH_MP4=ON";

  buildInputs = [ zlib ];
  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = http://developer.kde.org/~wheeler/taglib.html;
    repositories.git = git://github.com/taglib/taglib.git;

    description = "A library for reading and editing the meta-data of several popular audio formats";
    inherit (cmake.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
