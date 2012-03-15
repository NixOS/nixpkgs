{stdenv, fetchurl, cmake, zlib, libgcrypt}:

stdenv.mkDerivation rec {
  name = "libssh-0.5.2";
  src = fetchurl {
    url = "http://www.libssh.org/files/0.5/${name}.tar.gz";
    sha256 = "09xjb8ja8k3j3a0y3zjphhxwrnh1y618afcbbri48x87mz0vks21";
  };
  buildInputs = [ zlib libgcrypt ];
  buildNativeInputs = [ cmake ];
  cmakeFlags = "-DWITH_GCRYPT=ON";
  meta = {
    description = "SSH client library";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
