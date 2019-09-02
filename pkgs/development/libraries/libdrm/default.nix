{ stdenv, fetchurl, pkgconfig, meson, ninja, libpthreadstubs, libpciaccess, valgrind-light }:

stdenv.mkDerivation rec {
  pname = "libdrm";
  version = "2.4.99";

  src = fetchurl {
    url = "https://dri.freedesktop.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0pnsw4bmajzdbz8pk4wswdmw93shhympf2q9alhbnpfjgsf57gsd";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ libpthreadstubs libpciaccess valgrind-light ];

  patches = [ ./cross-build-nm-path.patch ];

  postPatch = ''
    for a in */*-symbol-check ; do
      patchShebangs $a
    done
  '';

  mesonFlags =
    [
      "-Dnm-path=${stdenv.cc.targetPrefix}nm"
      "-Dinstall-test-programs=true" ]
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
