{
  cargo,
  cmake,
  cpptoml,
  double-conversion,
  edencommon,
  ensureNewerSourcesForZipFilesHook,
  fb303,
  fbthrift,
  fetchFromGitHub,
  fetchpatch,
  fizz,
  folly,
  glog,
  gtest,
  lib,
  libevent,
  libsodium,
  libunwind,
  lz4,
  openssl,
  pcre2,
  pkg-config,
  rustPlatform,
  rustc,
  stateDir ? "/tmp",
  stdenv,
  wangle,
  zstd,
  apple-sdk_11,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "watchman";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-cD8mIYCc+8Z2p3rwKVRFcW9sOBbpb5KHU5VpbXHMpeg=";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_EDEN_SUPPORT=NO" # requires sapling (formerly known as eden), which is not packaged in nixpkgs
    "-DWATCHMAN_STATE_DIR=${stateDir}"
    "-DWATCHMAN_VERSION_OVERRIDE=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    ensureNewerSourcesForZipFilesHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs =
    [
      pcre2
      openssl
      gtest
      glog
      libevent
      libsodium
      folly
      fizz
      wangle
      fbthrift
      fb303
      cpptoml
      edencommon
      libunwind
      double-conversion
      lz4
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  cargoRoot = "watchman/cli";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  patches = [
    # fix build with rustc >=1.79
    (fetchpatch {
      url = "https://github.com/facebook/watchman/commit/c3536143cab534cdd9696eb3e2d03c4ac1e2f883.patch";
      hash = "sha256-lpGr5H28gfVXkWNdfDo4SCbF/p5jB4SNlHj6km/rfw4=";
    })
  ];

  postPatch = ''
    patchShebangs .
    cp ${./Cargo.lock} ${finalAttrs.cargoRoot}/Cargo.lock
  '';

  meta = {
    description = "Watches files and takes action when they change";
    homepage = "https://facebook.github.io/watchman";
    maintainers = with lib.maintainers; [ kylesferrazza ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
})
