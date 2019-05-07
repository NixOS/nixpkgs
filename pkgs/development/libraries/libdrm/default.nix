{ stdenv, fetchurl, pkgconfig, libpthreadstubs, libpciaccess, valgrind-light }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.97";

  src = fetchurl {
    url = "https://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "08yimlp6jir1rs5ajgdx74xa5qdzcqahpdzdk0rmkmhh7vdcrl3p";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpthreadstubs libpciaccess valgrind-light ];
    # libdrm as of 2.4.70 does not actually do anything with udev.

  postPatch = ''
    for a in */*-symbol-check ; do
      patchShebangs $a
    done
  '';

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
