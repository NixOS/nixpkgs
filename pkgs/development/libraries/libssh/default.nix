{ stdenv, fetchurl, cmake, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "libssh-0.5.5";

  src = fetchurl {
    url = "https://red.libssh.org/attachments/download/51/${name}.tar.gz";
    sha256 = "17cfdff4hc0ijzrr15biq29fiabafz0bw621zlkbwbc1zh2hzpy0";
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
