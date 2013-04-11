{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmspack-0.3alpha";
  src = fetchurl {
    url = http://www.cabextract.org.uk/libmspack/libmspack-0.3alpha.tar.gz;
    sha256 = "03rlzhvzd3qm7sb029gs14syq1z6xjmczvwb9kbz5sl20sjngidh";
  };

  meta = {
    description = "A de/compression library for various Microsoft formats";
    homepage = http://www.cabextract.org.uk/libmspack;
    license = "LGPL2";
  };

}
