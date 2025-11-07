{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  zlib,
  libevent,
  openssl,
  python3,
  cmake,
  pkg-config,
  bison,
  flex,
  ctestCheckHook,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thrift";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "thrift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gGAO+D0A/hEoHMm6OvRBc1Mks9y52kfd0q/Sg96pdW4=";
  };

  # Workaround to make the Python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [ ];

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
    (python3.withPackages (
      ps:
      with ps;
      [
        setuptools
        six
      ]
      ++ lib.optionals (!static) [
        twisted
      ]
    ))
  ];

  buildInputs = [
    boost
  ];

  strictDeps = true;

  propagatedBuildInputs = [
    libevent
    openssl
    zlib
  ];

  nativeCheckInputs = [ ctestCheckHook ];

  preConfigure = ''
    export PY_PREFIX=$out
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_JAVASCRIPT" false)
    (lib.cmakeBool "BUILD_NODEJS" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!static))
    (lib.cmakeBool "OPENSSL_USE_STATIC_LIBS" static)

    # FIXME: Fails to link in static mode with undefined reference to
    # `boost::unit_test::unit_test_main(bool (*)(), int, char**)'
    (lib.cmakeBool "BUILD_TESTING" (!static))
  ];

  disabledTests = [
    "UnitTests" # getaddrinfo() -> -3; Temporary failure in name resolution
    "python_test" # many failures about python 2 or network things
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Tests that hang up in the Darwin sandbox
    "SecurityTest"
    "SecurityFromBufferTest"
    "python_test"

    # fails on hydra, passes locally
    "concurrency_test"

    # Tests that fail in the Darwin sandbox when trying to use network
    "UnitTests"
    "TInterruptTest"
    "TServerIntegrationTest"
    "processor"
    "TNonblockingServerTest"
    "TNonblockingSSLServerTest"
    "StressTest"
    "StressTestConcurrent"
    "StressTestNonBlocking"
  ];

  doCheck = !static;

  enableParallelChecking = false;

  meta = with lib; {
    description = "Library for scalable cross-language services";
    mainProgram = "thrift";
    homepage = "https://thrift.apache.org/";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor ];
  };
})
