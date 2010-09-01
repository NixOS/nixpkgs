{stdenv, fetchurl}:

# I could not build it in armv5tel-linux or the fuloon2f
assert stdenv.system != "armv5tel-linux";
assert stdenv.system != "mips64-linux";
   
stdenv.mkDerivation {
  name = "libxcrypt-3.0.2";
   
  src = fetchurl {
    url = ftp://ftp.suse.com/pub/people/kukuk/libxcrypt/libxcrypt-3.0.2.tar.bz2;
    sha256 = "15l2xvhi3r3b40x4665c101ikylh5xsbpw03gnszypfjgn1jkcii";
  };
}
