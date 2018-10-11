{ stdenv, fetchurl, pkgconfig, meson, ninja, libpthreadstubs, libpciaccess, valgrind-light }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.95";

  src = fetchurl {
    url = "https://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "1ilmr2n5l0ivfw3hv06zvgh1jwx9inlxk51i4hn7mndyni8jlxzg";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ libpthreadstubs libpciaccess valgrind-light ];
    # libdrm as of 2.4.70 does not actually do anything with udev.

  patches = stdenv.lib.optional stdenv.isDarwin ./libdrm-apple.patch;

  postPatch = ''
    for a in */*-symbol-check ; do
      patchShebangs $a
    done
  '';

#  preConfigure = stdenv.lib.optionalString stdenv.isDarwin
#    "echo : \\\${ac_cv_func_clock_gettime=\'yes\'} > config.cache";
#
  mesonFlags = [ "-Dinstall-test-programs=true" ]
    ++ stdenv.lib.optionals (stdenv.isAarch32 || stdenv.isAarch64)
      [ "-Dtegra=true" "-Detnaviv=true" ]
    #++ stdenv.lib.optional stdenv.isDarwin "-C"
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "-Dintel=false"
    ;

  meta = {
    homepage = https://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
    platforms = stdenv.lib.platforms.unix;
  };
}
