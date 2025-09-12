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

  nix-update-script,

  stateDir ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "watchman";
  version = "2025.09.15.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZIFGCOoIuy4Ns51oek3HnBLtCSnI742FTA2YmorBpyk=";
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

    # The build system looks for `/usr/bin/python3`. It falls back
    # gracefully if it’s not found, but let’s dodge the potential
    # reproducibility risk for unsandboxed Darwin.
    substituteInPlace CMakeLists.txt \
      --replace-fail /usr/bin /var/empty

    # Facebook Thrift requires C++20 now but Watchman hasn’t been
    # updated yet… (Aren’t these things meant to be integrated together
    # in a monorepo?)
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_CXX_STANDARD 17)' 'set(CMAKE_CXX_STANDARD 20)'
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
