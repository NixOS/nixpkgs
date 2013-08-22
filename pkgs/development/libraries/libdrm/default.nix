{ stdenv, fetchurl, pkgconfig, libpthreadstubs, libpciaccess, udev }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.46";

  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "1wah4qmrrcv0gnx65lhrlxb6gprxch92wy8lhxv6102fml6k5krk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpthreadstubs libpciaccess ]
    ++ stdenv.lib.optional stdenv.isLinux udev;

  patches = stdenv.lib.optional stdenv.isDarwin ./libdrm-apple.patch;

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin
    "echo : \\\${ac_cv_func_clock_gettime=\'yes\'} > config.cache";

  configureFlags = stdenv.lib.optional stdenv.isLinux "--enable-udev"
    ++ stdenv.lib.optional stdenv.isDarwin "-C";

  crossAttrs.configureFlags = configureFlags ++ [ "--disable-intel" ];

  meta = {
    homepage = http://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
