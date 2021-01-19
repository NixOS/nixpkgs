{ stdenv, lib, fetchurl, pkg-config, meson, ninja, libpthreadstubs, libpciaccess
, withValgrind ? valgrind-light.meta.available, valgrind-light, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "libdrm";
  version = "2.4.103";

  src = fetchurl {
    url = "https://dri.freedesktop.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "08h2nnf4w96b4ql7485mvjgbbsb8rwc0qa93fdm1cq34pbyszq1z";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkg-config meson ninja ];
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
    homepage = "https://dri.freedesktop.org/libdrm/";
    description = "Library for accessing the kernel's Direct Rendering Manager";
    license = "bsd";
    platforms = lib.platforms.unix;
  };
}
