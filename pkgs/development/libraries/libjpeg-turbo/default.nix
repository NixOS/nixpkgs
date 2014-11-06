{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "1fbgcvlnn3d5gvf0v9jnlcabpv2z3nwxclzyabahxi6x2xs90cn1";
  };

  buildInputs = [ nasm ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = stdenv.lib.licenses.free;
  };
}
