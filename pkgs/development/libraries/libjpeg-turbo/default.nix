{ stdenv, fetchurl, nasm }: 

stdenv.mkDerivation {
  name = "libjpeg-turbo-1.1.1";
  
  src = fetchurl {
    url = mirror://sourceforge/libjpeg-turbo/libjpeg-turbo-1.1.1.tar.gz;
    sha256 = "553b1f5a968fb9efc089623ed99be2aa6bc21586be92eb04848489c91a63f1e2";
  };

  buildInputs = [ nasm ];
  
  meta = {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = "free";
  };
}
