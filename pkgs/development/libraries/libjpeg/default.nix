{ stdenv, fetchurl, libtool, static ? false }: 

stdenv.mkDerivation {
  name = "libjpeg-7";
  
  src = fetchurl {
    url = http://www.ijg.org/files/jpegsrc.v7.tar.gz;
    sha256 = "1gvy6f83pskxrxwnxqah3g9mhnlgi6aph39b99609gn50ri8ddsh";
  };
  
  configureFlags = "--enable-shared ${if static then " --enable-static" else ""}";

  meta = {
    homepage = http://www.ijg.org/;
    description = "A library that implements the JPEG image file format";
    license = "free";
  };
}
