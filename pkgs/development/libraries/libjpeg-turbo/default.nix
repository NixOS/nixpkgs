{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  name = "libjpeg-turbo-1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/libjpeg-turbo/${name}.tar.gz";
    sha256 = "1vmv5ciqq98gi2ishqbvlx9hsk7sl06lr6xkcgw480jiddadhfnr";
  };

  buildInputs = [ nasm ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = licenses.ijg; # and some parts under other BSD-style licenses
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}

