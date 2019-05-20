{ stdenv, fetchurl, pkgconfig, libpthreadstubs, libpciaccess, valgrind-light }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.98";

  src = fetchurl {
    url = "https://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "150qdzsm2nx6dfacc75rx53anzsc6m31nhxidf5xxax3mk6fvq4b";
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
