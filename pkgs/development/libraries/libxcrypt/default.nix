{stdenv, fetchurl}:
   
stdenv.mkDerivation {
  name = "libxcrypt-3.0.2";
   
  src = fetchurl {
    url = ftp://ftp.suse.com/pub/people/kukuk/libxcrypt/libxcrypt-3.0.2.tar.bz2;
    sha256 = "15l2xvhi3r3b40x4665c101ikylh5xsbpw03gnszypfjgn1jkcii";
  };
}
