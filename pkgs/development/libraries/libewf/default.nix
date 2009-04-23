{ fetchurl, stdenv, zlib, openssl, libuuid }:

stdenv.mkDerivation rec {
  name = "libewf-20080501";
  src = fetchurl {
    url = mirror://sourceforge/libewf/libewf-20080501.tar.gz;
    sha256 = "0s8fp7kmpk0976zii0fbk8vhi8k1br2fjp510rmgr6q1ssqdbi36";
  };

  buildInputs = [ zlib openssl libuuid ];

  meta = {
    description = "Library for support of the Expert Witness Compression Format";
    homepage = http://sourceforge.net/projects/libewf/;
    license = "free";
  };
}
