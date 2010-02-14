{stdenv, fetchurl, cmake, zlib, openssl}:

stdenv.mkDerivation {
  name = "libssh-0.4.1";
  src = fetchurl {
    url = http://www.libssh.org/files/libssh-0.4.1.tar.gz;
    sha256 = "0f12iyzwc2w5m5y1b6jzr08516vpfwwwrqqd4dkb6b0q2a1axlm6";
  };
  buildInputs = [ cmake zlib openssl ];
  meta = {
    description = "SSH client library";
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.sander ]; 
  };
}
