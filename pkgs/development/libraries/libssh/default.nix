{ stdenv, fetchurl, cmake, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "libssh-0.5.3";

  src = fetchurl {
    url = "https://red.libssh.org/attachments/download/38/${name}.tar.gz";
    sha256 = "1w6s217vjq0w3v5i0c5ql6m0ki1yz05g9snah3azxfkl9k4schpd";
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
