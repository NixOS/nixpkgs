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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "watchman";
  version = "2026.01.19.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Eh7IHYEavgVd2p+r1PzQrAdqPD5FlYiTp4TCon55byE=";
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
    # If we want to have one watchman per system, we need to have the state in
    # $HOME for reliability in face of differing TMPDIR values.
    # https://github.com/facebook/watchman/issues/1092
    (lib.cmakeBool "WATCHMAN_USE_XDG_STATE_HOME" true)

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

    # The build system looks for `/usr/bin/python3`. It falls back
    # gracefully if it’s not found, but let’s dodge the potential
    # reproducibility risk for unsandboxed Darwin.
    substituteInPlace CMakeLists.txt \
      --replace-fail /usr/bin /var/empty

  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Watches files and takes action when they change";
    homepage = "https://facebook.github.io/watchman";
    maintainers = with lib.maintainers; [
      kylesferrazza
      emily
      techknowlogick
      lf-
    ];
    mainProgram = "watchman";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
})
