{stdenv, fetchurl, pkgconfig, libpthreadstubs, libpciaccess, cairo, udev}:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.29";
  
  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "0bj5ihmnzpbbgdrvp5f8bgsk0k19haixr893449pjd4k7v4jshz2";
  };

  buildNativeInputs = [ pkgconfig ];
  buildInputs = [ libpthreadstubs libpciaccess cairo udev ];

  patches = stdenv.lib.optional stdenv.isDarwin ./libdrm-apple.patch;

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin
  "echo : \\\${ac_cv_func_clock_gettime=\'yes\'} > config.cache";

  configureFlags = [ "--enable-nouveau-experimental-api" "--enable-udev" ]
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
