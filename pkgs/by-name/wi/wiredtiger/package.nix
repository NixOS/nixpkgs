{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  swig,
  libsodium,
  lz4,
  snappy,
  zlib,
  zstd,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wiredtiger";
  version = "11.3.1";

  src = fetchFromGitHub {
    repo = "wiredtiger";
    owner = "wiredtiger";
    tag = finalAttrs.version;
    hash = "sha256-K5cZZTvZaWR6gVXF+mHNh7nHxMqi9XaEpB2qsd/pay8=";
  };

  nativeBuildInputs = [
    cmake
    python3
    swig
  ];

  buildInputs = [
    libsodium
    lz4
    snappy
    zlib
    zstd
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_STRICT" false)
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  env.NIX_CFLAGS_COMPILE = [ "-Wno-array-bounds" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://source.wiredtiger.com";
    description = "High performance, scalable, NoSQL, extensible platform for data management";
    mainProgram = "wt";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
    ];
    platforms = lib.intersectLists lib.platforms.unix lib.platforms.x86_64;
  };
})
