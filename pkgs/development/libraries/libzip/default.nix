{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "libzip-0.8";
  
  src = fetchurl {
    url = http://www.nih.at/libzip/libzip-0.8.tar.gz;
    sha256 = "0iy04c3b2yfwl9lpgwzm12qkdskbxj8l91r6mgn8f6ib00fj66ss";
  };
  
  buildInputs = [zlib];

  meta = {
    homepage = http://www.nih.at/libzip;
    description = "A C library for reading, creating and modifying zip archives";
  };
}
