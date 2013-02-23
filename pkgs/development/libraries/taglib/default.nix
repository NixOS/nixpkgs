{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.8";

  src = fetchurl {
    url = "https://github.com/downloads/taglib/taglib/${name}.tar.gz";
    sha256 = "16i0zjpxqqslbwi4kl6y15qwm15mh7ykh74x19m2741wf20k9lv6";
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
