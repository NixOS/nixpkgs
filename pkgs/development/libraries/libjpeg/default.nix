{ stdenv, fetchurl,
  ...}: 

stdenv.mkDerivation {
  name = "libjpeg-8";
  
  src = fetchurl {
    url = http://www.ijg.org/files/jpegsrc.v8.tar.gz;
    sha256 = "1b0blpk8v397klssk99l6ddsb64krcb29pbkbp8ziw5kmjvsbfhp";
  };
  
  meta = {
    homepage = http://www.ijg.org/;
    description = "A library that implements the JPEG image file format";
    license = "free";
  };
}
