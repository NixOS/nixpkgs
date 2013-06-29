{ stdenv, fetchurl, cmake, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "libssh-0.5.4";

  src = fetchurl {
    url = "https://red.libssh.org/attachments/download/41/libssh-0.5.4.tar.gz";
    sha256 = "106a9nzmr8q5kw809p5zdhmjrqv7p6609ai5c1n7xi7pxg52af2z";
  };

  buildInputs = [ zlib libgcrypt ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = "-DWITH_GCRYPT=ON";

  meta = {
    description = "SSH client library";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
