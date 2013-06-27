{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-1.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "0d0jwdmj3h89bxdxlwrys2mw18mqcj4rzgb5l2ndpah8zj600mr6";
  };

  buildInputs = [ nasm ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = "free";
  };
}
