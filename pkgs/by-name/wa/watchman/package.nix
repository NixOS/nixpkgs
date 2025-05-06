{
  lib,
  stdenv,

  fetchFromGitHub,

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

  gtest,

  nix-update-script,

  stateDir ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "watchman";
  version = "2025.04.21.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eZRrG7bgmh7hW7ihQISQP5pnWAVGhDLL93rCP7ZtUnA=";
  };

  patches = [
    ./glog-0.7.patch
  ];

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

  buildInputs = [
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

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Watches files and takes action when they change";
    homepage = "https://facebook.github.io/watchman";
    maintainers = with lib.maintainers; [
      kylesferrazza
      emily
      techknowlogick
    ];
    mainProgram = "watchman";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
})
