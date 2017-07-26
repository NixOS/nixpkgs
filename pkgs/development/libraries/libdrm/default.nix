{ stdenv, fetchurl, pkgconfig, libpthreadstubs, libpciaccess, valgrind-light }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.81";

  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "8cc05c195ac8708199979a94c4e4d1a928c14ec338ecbcb38ead09f54dae11ae";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpthreadstubs libpciaccess valgrind-light ];
    # libdrm as of 2.4.70 does not actually do anything with udev.

  patches = stdenv.lib.optional stdenv.isDarwin ./libdrm-apple.patch;

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin
    "echo : \\\${ac_cv_func_clock_gettime=\'yes\'} > config.cache";

  configureFlags = [ ]
    ++ stdenv.lib.optionals (stdenv.isArm || stdenv.isAarch64) [ "--enable-tegra-experimental-api" "--enable-etnaviv-experimental-api" ]
    ++ stdenv.lib.optional stdenv.isDarwin "-C";

  crossAttrs.configureFlags = configureFlags ++ [ "--disable-intel" ];

  meta = {
    homepage = http://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
    platforms = stdenv.lib.platforms.unix;
  };
}
