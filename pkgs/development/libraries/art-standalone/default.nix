{
  lib,
  stdenv,
  fetchFromGitLab,
  wolfssl,
  bionic-translation,
  python3,
  which,
  jdk17,
  zip,
  xz,
  icu,
  zlib,
  libcap,
  expat,
  openssl,
  libbsd,
  lz4,
  runtimeShell,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "art-standalone";
  version = "0-unstable-2025-01-15";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "art_standalone";
    rev = "aa709f68d03e83d35c5e8a58e77760e5be9185bc";
    hash = "sha256-YNAXbtcaZHWaFPbJ+wUFfuHAwU3HrwF6tx6lQzlkWZA=";
  };

  patches = [ ./add-liblog-dep.patch ];

  enableParallelBuilding = true;

  strictDeps = true;

  nativeBuildInputs = [
    jdk17
    python3
    which
    zip
  ];

  buildInputs = [
    bionic-translation
    expat
    icu
    libbsd
    libcap
    lz4
    openssl
    wolfssl
    xz
    zlib
  ];

  postPatch = ''
    chmod +x dalvik/dx/etc/{dx,dexmerger}
    patchShebangs .
    sed -i "s|/bin/bash|${runtimeShell}|" build/core/config.mk build/core/main.mk
  '';

  makeFlags = [
    "____LIBDIR=lib"
    "____PREFIX=${placeholder "out"}"
    "____INSTALL_ETC=${placeholder "out"}/etc"
  ];

  meta = {
    description = "Art and dependencies with modifications to make it work on Linux";
    homepage = "https://gitlab.com/android_translation_layer/art_standalone";
    # No license specified yet
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
})
