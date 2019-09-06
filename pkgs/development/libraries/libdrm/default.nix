{ stdenv, lib, fetchurl, pkgconfig, meson, ninja, libpthreadstubs, libpciaccess
, withValgrind ? valgrind-light.meta.available, valgrind-light
}:

stdenv.mkDerivation rec {
  pname = "libdrm";
  version = "2.4.99";

  src = fetchurl {
    url = "https://dri.freedesktop.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0pnsw4bmajzdbz8pk4wswdmw93shhympf2q9alhbnpfjgsf57gsd";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ libpthreadstubs libpciaccess ]
    ++ lib.optional withValgrind valgrind-light;

  patches = [ ./cross-build-nm-path.patch ];

  postPatch = ''
    for a in */*-symbol-check ; do
      patchShebangs $a
    done
  '';

  mesonFlags = [
    "-Dnm-path=${stdenv.cc.targetPrefix}nm"
    "-Dinstall-test-programs=true"
    "-Domap=true"
  ] ++ lib.optionals (stdenv.isAarch32 || stdenv.isAarch64) [
    "-Dtegra=true"
    "-Detnaviv=true"
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "-Dintel=false";

  enableParallelBuilding = true;

  meta = {
    homepage = https://dri.freedesktop.org/libdrm/;
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
    platforms = lib.platforms.unix;
  };
}
