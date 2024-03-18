{ lib
, stdenv
, fetchFromGitHub
, boost
, zlib
, libevent
, openssl
, python3
, cmake
, pkg-config
, bison
, flex
, glibcLocales
, nix-update-script
, testers
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thrift";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "thrift";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-cwFTcaNHq8/JJcQxWSelwAGOLvZHoMmjGV3HBumgcWo=";
  };

  # Workaround to make the Python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [];

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
    python3
    python3.pkgs.setuptools
  ];

  buildInputs = [
    boost
  ] ++ lib.optionals (!static) [
    (python3.withPackages (ps: [
      ps.tornado
      ps.twisted
    ]))
  ];

  propagatedBuildInputs = [
    libevent
    openssl
    zlib
  ];

  postPatch = ''
    # Python 3.10 related failures:
    # SystemError: PY_SSIZE_T_CLEAN macro must be defined for '#' formats
    # AttributeError: module 'collections' has no attribute 'Hashable'
    substituteInPlace test/py/RunClientServer.py \
      --replace "'FastbinaryTest.py'," "" \
      --replace "'TestEof.py'," "" \
      --replace "'TestFrozen.py'," ""

    # these functions are removed in Python3.12
    substituteInPlace test/py/SerializationTest.py \
      --replace-fail "assertEquals" "assertEqual" \
      --replace-fail "assertNotEquals" "assertNotEqual"
  '';

  preConfigure = ''
    export PY_PREFIX=$out
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_JAVASCRIPT" false)
    (lib.cmakeBool "BUILD_NODEJS" false)

    # FIXME: Fails to link in static mode with undefined reference to
    # `boost::unit_test::unit_test_main(bool (*)(), int, char**)'
    (lib.cmakeBool "BUILD_TESTING" (!static))
    (lib.cmakeBool "WITH_STATIC_LIB" static)
    (lib.cmakeBool "OPENSSL_USE_STATIC_LIBS" static)
  ];

  doCheck = !static;

  nativeCheckInputs = [
    glibcLocales
  ];

  checkPhase =
    let
      disabledTests = [
        "PythonTestSSLSocket"
        "PythonThriftTNonblockingServer"
        "python_test"
      ] ++ lib.optionals stdenv.isDarwin [
        # Tests that hang up in the Darwin sandbox
        "SecurityTest"
        "SecurityFromBufferTest"

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
    in ''
      runHook preCheck

      export LD_LIBRARY_PATH=$PWD/lib
      export DYLD_LIBRARY_PATH=$PWD/lib
      ctest -E '^${lib.concatStringsSep "|" disabledTests}$'

      runHook postCheck
    '';

  enableParallelChecking = false;

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "thrift -version";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Library for scalable cross-language services";
    mainProgram = "thrift";
    homepage = "https://thrift.apache.org/";
    changelog = "https://github.com/apache/thrift/blob/v${finalAttrs.version}/CHANGES.md";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor anthonyroussel ];
  };
})
