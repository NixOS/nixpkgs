{ stdenv, fetchurl }: 

stdenv.mkDerivation {
  name = "libjpeg-8";
  
  src = fetchurl {
    url = http://www.ijg.org/files/jpegsrc.v8b.tar.gz;
    sha256 = "19vl6587pyhz45f14yipnsnpni4iz6j0wdzwyblbm4f5vs721rin";
  };
  
  meta = {
    homepage = http://www.ijg.org/;
    description = "A library that implements the JPEG image file format";
    license = "free";
  };
}
