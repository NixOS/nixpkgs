{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmspack-0.4alpha";
  src = fetchurl {
    url = http://www.cabextract.org.uk/libmspack/libmspack-0.4alpha.tar.gz;
    sha256 = "0s2w5zxx9cw7445cx9ap59ky5n7r201551zg906w9ghcys1qk5dp";
  };

  meta = {
    description = "A de/compression library for various Microsoft formats";
    homepage = http://www.cabextract.org.uk/libmspack;
    license = "LGPL2";
  };

}
