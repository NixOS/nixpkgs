{ stdenv, fetchurl, pkgconfig, libpthreadstubs, libpciaccess, valgrind-light }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.93";

  src = fetchurl {
    url = "https://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "0g6d9wsnb7lx8r1m4kq8js0wsc5jl20cz1csnlh6z9s8jpfd313f";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpthreadstubs libpciaccess valgrind-light ];
    # libdrm as of 2.4.70 does not actually do anything with udev.

  patches = stdenv.lib.optional stdenv.isDarwin ./libdrm-apple.patch;

  postPatch = ''
    for a in */*-symbol-check ; do
      patchShebangs $a
    done
  '';

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin
    "echo : \\\${ac_cv_func_clock_gettime=\'yes\'} > config.cache";

  configureFlags = [ "--enable-install-test-programs" ]
    ++ stdenv.lib.optionals (stdenv.isAarch32 || stdenv.isAarch64)
      [ "--enable-tegra-experimental-api" "--enable-etnaviv-experimental-api" ]
    ++ stdenv.lib.optional stdenv.isDarwin "-C"
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--disable-intel"
    ;

  meta = {
    homepage = https://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
    platforms = stdenv.lib.platforms.unix;
  };
}
