{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-1.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "0w1pj3j7hkx6irkrxlcmz53l94s6im0wml1v36nysb50akq26cyb";
  };

  buildInputs = [ nasm ];

  meta = {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = "free";
  };
}
