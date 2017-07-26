{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.10";

  src = fetchurl {
    url = "http://taglib.github.io/releases/${name}.tar.gz";
    sha256 = "1alv6vp72p0x9i9yscmz2a71anjwqy53y9pbcbqxvc1c0i82vhr4";
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
