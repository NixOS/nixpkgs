{ stdenv, lib, fetchurl, pkg-config, meson, ninja, docutils
, libpthreadstubs, libpciaccess
, withValgrind ? valgrind-light.meta.available, valgrind-light
}:

stdenv.mkDerivation rec {
  pname = "libdrm";
  version = "2.4.112";

  src = fetchurl {
    url = "https://dri.freedesktop.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1zr0hi7k5s7my4q9hyj6ryzg89zyjx24zbqfv3c5rcq9pl87gc00";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkg-config meson ninja docutils ];
  buildInputs = [ libpthreadstubs libpciaccess ]
    ++ lib.optional withValgrind valgrind-light;

  mesonFlags = [
    "-Dinstall-test-programs=true"
    "-Domap=true"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch [
    "-Dtegra=true"
    "-Detnaviv=true"
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
