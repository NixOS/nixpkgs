{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libmodbus-3.1.6";

  src = fetchurl {
    url = "http://libmodbus.org/releases/${name}.tar.gz";
    sha256 = "05kwz0n5gn9m33cflzv87lz3zp502yp8fpfzbx70knvfl6agmnfp";
  };

  configureFlags = [
    # when cross-compiling we assume that the host system will return a valid
    # pointer for calls to malloc(0) or realloc(0)
    # https://www.uclibc.org/FAQ.html#gnu_malloc
    # https://www.gnu.org/software/autoconf/manual/autoconf.html#index-AC_005fFUNC_005fMALLOC-454
    # the upstream source should be patched to avoid needing this
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = with lib; {
    description = "Library to send/receive data according to the Modbus protocol";
    homepage = "https://libmodbus.org/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
