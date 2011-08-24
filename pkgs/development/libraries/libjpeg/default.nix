{ stdenv, fetchurl }: 

stdenv.mkDerivation {
  name = "libjpeg-8c";
  
  src = fetchurl {
    url = http://www.ijg.org/files/jpegsrc.v8c.tar.gz;
    sha256 = "16kwrjhziv81gl9fq9b7qir8khm3wfb9zj7fzs7yabsb00z0pz7d";
  };
  
  meta = {
    homepage = http://www.ijg.org/;
    description = "A library that implements the JPEG image file format";
    license = "free";
  };
}
