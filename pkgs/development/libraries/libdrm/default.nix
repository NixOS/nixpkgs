{ stdenv, lib, fetchurl, pkg-config, meson, ninja, docutils
, libpthreadstubs, libpciaccess
, withValgrind ? lib.meta.availableOn stdenv.hostPlatform valgrind-light, valgrind-light
}:

stdenv.mkDerivation rec {
  pname = "libdrm";
  version = "2.4.115";

  src = fetchurl {
    url = "https://dri.freedesktop.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-VUz7/gVCvds5G04+Bb+7/D4oK5Vb1WIY0hwGFkgfZes=";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkg-config meson ninja docutils ];
  buildInputs = [ libpthreadstubs libpciaccess ]
    ++ lib.optional withValgrind valgrind-light;

  mesonFlags = [
    "-Dinstall-test-programs=true"
    "-Dcairo-tests=disabled"
    (lib.mesonEnable "omap" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "valgrind" withValgrind)
  ] ++ lib.optionals stdenv.hostPlatform.isAarch [
    "-Dtegra=enabled"
  ] ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    "-Detnaviv=disabled"
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/mesa/drm";
    downloadPage = "https://dri.freedesktop.org/libdrm/";
    description = "Direct Rendering Manager library and headers";
    longDescription = ''
      A userspace library for accessing the DRM (Direct Rendering Manager) on
      Linux, BSD and other operating systems that support the ioctl interface.
      The library provides wrapper functions for the ioctls to avoid exposing
      the kernel interface directly, and for chipsets with drm memory manager,
      support for tracking relocations and buffers.
      New functionality in the kernel DRM drivers typically requires a new
      libdrm, but a new libdrm will always work with an older kernel.

      libdrm is a low-level library, typically used by graphics drivers such as
      the Mesa drivers, the X drivers, libva and similar projects.
    '';
    license = licenses.mit;
    platforms = lib.subtractLists platforms.darwin platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
