{ stdenv, fetchurl, pkgconfig, libpthreadstubs, libpciaccess, udev }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.34";
  
  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "1l7qs2qa0kxpbd28yqc2cjl0v2lgmbmyxb4f5xy7n445gh75fs54";
  };

  buildNativeInputs = [ pkgconfig ];
  buildInputs = [ libpthreadstubs libpciaccess udev ];

  patches = stdenv.lib.optional stdenv.isDarwin ./libdrm-apple.patch;

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin
    "echo : \\\${ac_cv_func_clock_gettime=\'yes\'} > config.cache";

  configureFlags = [ "--enable-udev" ]
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
