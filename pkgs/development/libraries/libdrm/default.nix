{ stdenv, fetchurl, pkgconfig, libpthreadstubs, libpciaccess, udev, valgrind }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.68";

  src = fetchurl {
    url = "http://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "5b4bd9a5922929bc716411cb74061fbf31b06ba36feb89bc1358a91a8d0ca9df";
  };

  outputs = [ "dev" "out" ];

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
