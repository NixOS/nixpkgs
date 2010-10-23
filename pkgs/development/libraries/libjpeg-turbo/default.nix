{ stdenv, fetchurl, nasm }: 

stdenv.mkDerivation {
  name = "libjpeg-turbo-1.0.1";
  
  src = fetchurl {
    url = mirror://sourceforge/libjpeg-turbo/libjpeg-turbo-1.0.1.tar.gz;
    sha256 = "094jvqzibqbzmhh7mz3xi76lzlilxzb4j1x8rpdcdkzyig9dizqf";
  };

  buildInputs = [ nasm ];
  
  meta = {
    homepage = http://libjpeg-turbo.virtualgl.org/;
    description = "A faster (using SIMD) libjpeg implementation";
    license = "free";
  };
}
