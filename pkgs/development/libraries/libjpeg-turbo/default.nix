{ stdenv, fetchurl, nasm, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "1fbgcvlnn3d5gvf0v9jnlcabpv2z3nwxclzyabahxi6x2xs90cn1";
  };

  outputs = [ "dev" "out" "doc" "bin" ];

  buildInputs = [ stdenv.hookLib.multiout autoreconfHook nasm ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = "free";
  };
}
