{ stdenv, fetchurl, pkgconfig, libpthreadstubs, libpciaccess, udev, valgrind }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.64";

  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "1dilm6cwqfx9plf3i5kkaf6m5v1zyrcadqbcjsrsshkfgpz8c1xn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpthreadstubs libpciaccess ]
    ++ stdenv.lib.optional stdenv.isLinux udev;

  patches = stdenv.lib.optional stdenv.isDarwin ./libdrm-apple.patch;

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin
    "echo : \\\${ac_cv_func_clock_gettime=\'yes\'} > config.cache";

  configureFlags = [ "--enable-freedreno" "--disable-valgrind" ]
    ++ stdenv.lib.optional stdenv.isLinux "--enable-udev"
    ++ stdenv.lib.optional stdenv.isDarwin "-C";

  crossAttrs.configureFlags = configureFlags ++ [ "--disable-intel" ];

  meta = {
    homepage = http://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.unix;
  };
}
