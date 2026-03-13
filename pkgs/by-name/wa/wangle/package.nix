{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,

  folly,
  fizz,
  openssl,
  glog,
  gflags,
  libevent,
  double-conversion,

  ctestCheckHook,

  gtest,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wangle";
  version = "2026.03.16.00";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wangle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uP4If0+m3K8S2TqkTY/HdhOYaHLQsmDuja2IhCbdVA8=";
  };

  # the filter for non-public directories collides with nix build directory
  postPatch = ''
    substituteInPlace wangle/CMakeLists.txt --replace-fail 'list(FILTER WANGLE_HEADERS EXCLUDE REGEX "/build/")' ""
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    folly
    fizz
    openssl
    glog
    gflags
    libevent
    double-conversion
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  checkInputs = [
    gtest
  ];

  cmakeDir = "../wangle";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)

    (lib.cmakeFeature "INCLUDE_INSTALL_DIR" "${placeholder "dev"}/include")
    (lib.cmakeFeature "LIB_INSTALL_DIR" "${placeholder "out"}/lib")
    (lib.cmakeFeature "CMAKE_INSTALL_DIR" "${placeholder "dev"}/lib/cmake/wangle")
  ];

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  dontUseNinjaCheck = true;

  disabledTests = [
    # Deterministic glibc abort 🫠
    "BootstrapTest"
    "BroadcastPoolTest"

    # SSLContextManagerTest uses 15+ GB of RAM
    "SSLContextManagerTest"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source C++ networking library";
    longDescription = ''
      Wangle is a framework providing a set of common client/server
      abstractions for building services in a consistent, modular, and
      composable way.
    '';
    homepage = "https://github.com/facebook/wangle";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pierreis
      kylesferrazza
      emily
      techknowlogick
      lf-
    ];
  };
})
