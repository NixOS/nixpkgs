{ stdenv, fetchurl, pkgconfig, libpthreadstubs, libpciaccess, valgrind }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.79";

  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "c6aaf319293bce38023e9a637471b0f45c93c807d2a279060d741fc7a2e5b197";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpthreadstubs libpciaccess ];
    # libdrm as of 2.4.70 does not actually do anything with udev.

  patches = stdenv.lib.optional stdenv.isDarwin ./libdrm-apple.patch;

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin
    "echo : \\\${ac_cv_func_clock_gettime=\'yes\'} > config.cache";

  configureFlags = [ "--disable-valgrind" ]
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
