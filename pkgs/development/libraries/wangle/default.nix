{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  boost,
  libevent,
  double-conversion,
  glog,
  fmt_8,
  gflags,
  openssl,
  fizz,
  folly,
  gtest,
  libsodium,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wangle";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wangle";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fDtJ+9bZj+siKlMglYMkLO/+jldUmsS5V3Umk1gNdlo=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeDir = "../wangle";

  cmakeFlags =
    [
      "-Wno-dev"
      (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    ]
    ++ lib.optionals stdenv.isDarwin [
      "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.14" # For aligned allocation
    ];

  buildInputs = [
    fmt_8
    libsodium
    zlib
    boost
    double-conversion
    fizz
    folly
    glog
    gflags
    libevent
    openssl
  ];

  doCheck = true;
  checkInputs = [
    gtest
  ];
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
        ++ lib.optionals stdenv.isDarwin [
          # flaky
          "BroadcastPoolTest.ThreadLocalPool"
          "Bootstrap.UDPClientServerTest"
        ];
    in
    ''
      export GTEST_FILTER="-${lib.concatStringsSep ":" disabledTests}"
    '';

  meta = with lib; {
    description = "An open-source C++ networking library";
    longDescription = ''
      Wangle is a framework providing a set of common client/server
      abstractions for building services in a consistent, modular, and
      composable way.
    '';
    homepage = "https://github.com/facebook/wangle";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      pierreis
      kylesferrazza
    ];
  };
})
