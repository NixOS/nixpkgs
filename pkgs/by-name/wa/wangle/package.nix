{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,
  removeReferencesTo,

  folly,
  fizz,
  openssl,
  glog,
  gflags,
  libevent,
  double-conversion,
  apple-sdk_11,
  darwinMinVersionHook,

  gtest,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wangle";
  version = "2024.11.18.00";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wangle";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-4mqE9GgJP2f7QAykwdhMFoReE9wmPKOXqSHJ2MHP2G0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    removeReferencesTo
  ];

  buildInputs =
    [
      folly
      fizz
      openssl
      glog
      gflags
      libevent
      double-conversion
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
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

  env.GTEST_FILTER =
    "-"
    + lib.concatStringsSep ":" (
      [
        # these depend on example pem files from the folly source tree (?)
        "SSLContextManagerTest.TestSingleClientCAFileSet"
        "SSLContextManagerTest.TestMultipleClientCAsSet"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # flaky
        "BroadcastPoolTest.ThreadLocalPool"
        "Bootstrap.UDPClientServerTest"
      ]
    );

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ctest -j $NIX_BUILD_CORES --output-on-failure ${
      # Deterministic glibc abort 🫠
      # SSLContextManagerTest uses 15+ GB of RAM
      lib.optionalString stdenv.hostPlatform.isLinux (
        lib.escapeShellArgs [
          "--exclude-regex"
          "^(BootstrapTest|BroadcastPoolTest|SSLContextManagerTest)$"
        ]
      )
    }

    runHook postCheck
  '';

  postFixup = ''
    # Sanitize header paths to avoid runtime dependencies leaking in
    # through `__FILE__`.
    (
      shopt -s globstar
      for header in "$dev/include"/**/*.h; do
        sed -i "1i#line 1 \"$header\"" "$header"
        remove-references-to -t "$dev" "$header"
      done
    )
  '';

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
    ];
  };
})
