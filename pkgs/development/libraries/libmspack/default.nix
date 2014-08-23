{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmspack-0.4alpha";
  src = fetchurl {
    # upstream url: "curl: (22) The requested URL returned error: 406 Not Acceptable"
    #url = http://www.cabextract.org.uk/libmspack/libmspack-0.4alpha.tar.gz;
    url = "http://pkgs.fedoraproject.org/lookaside/pkgs/libmspack/"
      + "libmspack-0.4alpha.tar.gz/1ab10b507259993c74b4c41a88103b59/libmspack-0.4alpha.tar.gz";
    sha256 = "0s2w5zxx9cw7445cx9ap59ky5n7r201551zg906w9ghcys1qk5dp";
  };

  meta = {
    description = "A de/compression library for various Microsoft formats";
    homepage = http://www.cabextract.org.uk/libmspack;
    license = stdenv.lib.licenses.lgpl2;
  };

}
