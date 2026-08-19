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
  buildPackages,
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

  postPatch = lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    # Compiling the tests doesn't work for cross builds.
    substituteInPlace lib/py/CMakeLists.txt \
      --replace-fail 'COMMAND ''${THRIFT_COMPILER} --gen py test/test_thrift_file/TestServer.thrift' ""
  '';

  # Workaround to make the Python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [ ];

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
    (buildPackages.python3.withPackages (
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
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    # Building tutorials requires running thrift.
    (lib.cmakeBool "BUILD_TUTORIALS" (stdenv.buildPlatform.canExecute stdenv.hostPlatform))
  ];

  disabledTests = [
    "UnitTests" # getaddrinfo() -> -3; Temporary failure in name resolution
    "python_test" # many failures about python 2 or network things
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Tests that hang up in the Darwin sandbox
    "SecurityTest"
    "SecurityFromBufferTest"
    "PythonThriftTNonblockingServer"

    # fails on hydra, passes locally
    "concurrency_test"

    # Tests that fail in the Darwin sandbox when trying to use network
    "UnitTests"
    "TInterruptTest"
    "TServerIntegrationTest"
    "processor"
    "processor_test"
    "TNonblockingServerTest"
    "TNonblockingSSLServerTest"
    "StressTest"
    "StressTestConcurrent"
    "StressTestNonBlocking"
  ];

  doCheck = !static;

  enableParallelChecking = false;

  meta = {
    description = "Library for scalable cross-language services";
    mainProgram = "thrift";
    homepage = "https://thrift.apache.org/";
    downloadPage = "https://github.com/apache/thrift";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
})
