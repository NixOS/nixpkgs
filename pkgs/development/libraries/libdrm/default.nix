{ stdenv, lib, fetchurl, pkgconfig, meson, ninja, libpthreadstubs, libpciaccess
, withValgrind ? valgrind-light.meta.available, valgrind-light, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "libdrm";
  version = "2.4.100";

  src = fetchurl {
    url = "https://dri.freedesktop.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0p8a1l3a3s40i81mawm8nhrbk7p97ss05qkawp1yx73c30lchz67";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ libpthreadstubs libpciaccess ]
    ++ lib.optional withValgrind valgrind-light;

  patches = [ ./cross-build-nm-path.patch ] ++
    lib.optionals stdenv.hostPlatform.isMusl [
      # Fix tests not building on musl because they use the glibc-specific
      # (non-POSIX) `ioctl()` type signature. See #66441.
      (fetchpatch {
        url = "https://raw.githubusercontent.com/openembedded/openembedded-core/30a2af80f5f8c8ddf0f619e4f50451b02baa22dd/meta/recipes-graphics/drm/libdrm/musl-ioctl.patch";
        sha256 = "0rdmh4k5kb80hhk1sdhlil30yf0s8d8w0fnq0hzyvw3ir1mki3by";
      })
    ];

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
