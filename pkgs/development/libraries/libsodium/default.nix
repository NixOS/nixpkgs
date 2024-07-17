{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsodium";
  version = "1.0.19";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-AY15/goEXMoHMx03vQy1ey6DjFG8SP2DehRy5QBou+o=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Drop -Ofast as it breaks floating point arithmetics in downstream
    # users.
    (fetchpatch {
      name = "drop-Ofast.patch";
      url = "https://github.com/jedisct1/libsodium/commit/ffd1e374989197b44d815ac8b5d8f0b43b6ce534.patch";
      hash = "sha256-jG0VirIoFBwYmRx6zHSu2xe6pXYwbeqNVhPJxO6eJEY=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  separateDebugInfo = stdenv.isLinux && stdenv.hostPlatform.libc != "musl";

  enableParallelBuilding = true;
  hardeningDisable = lib.optional (
    stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isx86_32
  ) "stackprotector";

  # FIXME: the hardeingDisable attr above does not seems effective, so
  # the need to disable stackprotector via configureFlags
  configureFlags = lib.optional (
    stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isx86_32
  ) "--disable-ssp";

  doCheck = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "A modern and easy-to-use crypto library";
    homepage = "https://doc.libsodium.org/";
    license = licenses.isc;
    maintainers = with maintainers; [ raskin ];
    pkgConfigModules = [ "libsodium" ];
    platforms = platforms.all;
  };
})
