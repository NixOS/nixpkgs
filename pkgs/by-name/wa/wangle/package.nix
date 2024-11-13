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
  apple-sdk_11,
  darwinMinVersionHook,

  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wangle";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wangle";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-fDtJ+9bZj+siKlMglYMkLO/+jldUmsS5V3Umk1gNdlo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
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
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  preCheck =
    let
      disabledTests =
        [
          # these depend on example pem files from the folly source tree (?)
          "SSLContextManagerTest.TestSingleClientCAFileSet"
          "SSLContextManagerTest.TestMultipleClientCAsSet"

          # https://github.com/facebook/wangle/issues/206
          "SSLContextManagerTest.TestSessionContextCertRemoval"
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          # flaky
          "BroadcastPoolTest.ThreadLocalPool"
          "Bootstrap.UDPClientServerTest"
        ];
    in
    ''
      export GTEST_FILTER="-${lib.concatStringsSep ":" disabledTests}"
    '';

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
    ];
  };
})
