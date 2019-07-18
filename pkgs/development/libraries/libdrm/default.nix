{ stdenv, fetchurl, pkgconfig, meson, ninja, libpthreadstubs, libpciaccess, valgrind-light }:

stdenv.mkDerivation rec {
  name = "libdrm-2.4.98";

  src = fetchurl {
    url = "https://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    sha256 = "150qdzsm2nx6dfacc75rx53anzsc6m31nhxidf5xxax3mk6fvq4b";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ libpthreadstubs libpciaccess valgrind-light ];

  postPatch = ''
    for a in */*-symbol-check ; do
      patchShebangs $a
    done
  '';

  mesonFlags =
    [ "-Dinstall-test-programs=true" ]
    ++ stdenv.lib.optionals (stdenv.isAarch32 || stdenv.isAarch64)
      [ "-Dtegra=true" "-Detnaviv=true" ]
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "-Dintel=false"
    ;

  enableParallelBuilding = true;

  meta = {
    homepage = https://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
    platforms = stdenv.lib.platforms.unix;
  };
}
