{stdenv, fetchurl, cmake, zlib, openssl}:

stdenv.mkDerivation {
  name = "libssh-0.4.8";
  src = fetchurl {
    url = http://www.libssh.org/files/0.4/libssh-0.4.8.tar.gz;
    sha256 = "05d8i8hwya2gry3lky9pmjpvr9f4wvggszqjjzgxvyy74sj3khhm";
  };
  buildInputs = [ cmake zlib openssl ];
  meta = {
    description = "SSH client library";
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.sander ]; 
  };
}
