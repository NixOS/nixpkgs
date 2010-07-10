{ stdenv, fetchurl, nasm }: 

stdenv.mkDerivation {
  name = "libjpeg-turbo-1.0.0";
  
  src = fetchurl {
    url = mirror://sourceforge/libjpeg-turbo/libjpeg-turbo-1.0.0.tar.gz;
    sha256 = "17zvyckjbscrr9b8i43g6g0960q5ammf4r93hkkx7s4hzjxvmkfj";
  };

  buildInputs = [ nasm ];
  
  meta = {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = "free";
  };
}
