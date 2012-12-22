{ stdenv, fetchurl }: 

stdenv.mkDerivation {
  name = "libjpeg-8d";
  
  src = fetchurl {
    url = http://www.ijg.org/files/jpegsrc.v8d.tar.gz;
    sha256 = "1cz0dy05mgxqdgjf52p54yxpyy95rgl30cnazdrfmw7hfca9n0h0";
  };
  
  meta = {
    homepage = http://www.ijg.org/;
    description = "A library that implements the JPEG image file format";
    license = "free";
  };
}
