{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchpatch,

  cmake,
  ninja,
  pkg-config,
  rustc,
  cargo,
  rustPlatform,
  ensureNewerSourcesForZipFilesHook,
  removeReferencesTo,

  pcre2,
  openssl,
  gflags,
  glog,
  libevent,
  edencommon,
  folly,
  fizz,
  wangle,
  fbthrift,
  fb303,
  cpptoml,
  apple-sdk_11,
  darwinMinVersionHook,

  gtest,

  nix-update-script,

  stateDir ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "watchman";
  version = "2024.11.18.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-deOSeExhwn8wrtP2Y0BDaHdmaeiUaDBok6W7N1rH/24=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    rustc
    cargo
    rustPlatform.cargoSetupHook
    ensureNewerSourcesForZipFilesHook
    removeReferencesTo
  ];

  buildInputs =
    [
      pcre2
      openssl
      gflags
      glog
      libevent
      edencommon
      folly
      fizz
      wangle
      fbthrift
      fb303
      cpptoml
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "CMAKE_INSTALL_RPATH_USE_LINK_PATH" true)

    (lib.cmakeFeature "WATCHMAN_STATE_DIR" stateDir)
    (lib.cmakeFeature "WATCHMAN_VERSION_OVERRIDE" finalAttrs.version)
  ];

  cargoRoot = "watchman/cli";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  doCheck = true;

  postPatch = ''
    patchShebangs .
    cp ${./Cargo.lock} ${finalAttrs.cargoRoot}/Cargo.lock
  '';

  postFixup = ''
    # TODO: Do this in `fmt` rather than downstream.
    remove-references-to -t ${folly.fmt.dev} $out/bin/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Watches files and takes action when they change";
    homepage = "https://facebook.github.io/watchman";
    maintainers = with lib.maintainers; [
      kylesferrazza
      emily
      techknowlogick
    ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
})
