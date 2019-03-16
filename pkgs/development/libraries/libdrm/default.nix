{ stdenv, fetchgit, meson, ninja, pkgconfig,
  libpthreadstubs, libpciaccess, valgrind-light }:

stdenv.mkDerivation rec {
  name = "libdrm-${version}";
  version = "2.4.97";
  rev = "${name}";
  sha256 = "065w0zyyfv3yzlw76pvsdjrkxd46wp5cwv472766is0mbi212rdp";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/mesa/drm";
    inherit rev sha256;
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ libpthreadstubs libpciaccess valgrind-light ];

  patches = stdenv.lib.optional stdenv.isDarwin ./libdrm-apple.patch;

  postPatch = ''
    for a in */*-symbol-check ; do
      patchShebangs $a
    done
  '';

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin
    "echo : \\\${ac_cv_func_clock_gettime=\'yes\'} > config.cache";

  mesonFlags =
    [ "-Dinstall-test-programs=true" ]
    ++ stdenv.lib.optionals (stdenv.isAarch32 || stdenv.isAarch64)
      [ "--enable-tegra-experimental-api" "--enable-etnaviv-experimental-api" ]
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
