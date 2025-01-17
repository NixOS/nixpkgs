{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  boost,
  zlib,
  libevent,
  openssl,
  python3,
  cmake,
  pkg-config,
  bison,
  flex,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "thrift";
  version = "0.18.1";

  src = fetchurl {
    url = "https://archive.apache.org/dist/thrift/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-BMbxDl14jKeOE+4u8NIVLHsHDAr1VIPWuULinP8pZyY=";
  };

  # Workaround to make the Python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [ ];

  nativeBuildInputs =
    [
      bison
      cmake
      flex
      pkg-config
      python3
      python3.pkgs.setuptools
    ]
    ++ lib.optionals (!static) [
      python3.pkgs.twisted
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

  patches = [
    # ToStringTest.cpp is failing from some reason due to locale issue, this
    # doesn't disable all UnitTests as in Darwin.
    ./disable-failing-test.patch
    (fetchpatch {
      name = "setuptools-gte-62.1.0.patch"; # https://github.com/apache/thrift/pull/2635
      url = "https://github.com/apache/thrift/commit/c41ad9d5119e9bdae1746167e77e224f390f2c42.diff";
      hash = "sha256-FkErrg/6vXTomS4AsCsld7t+Iccc55ZiDaNjJ3W1km0=";
    })
    (fetchpatch {
      name = "thrift-install-FindLibevent.patch"; # https://github.com/apache/thrift/pull/2726
      url = "https://github.com/apache/thrift/commit/2ab850824f75d448f2ba14a468fb77d2594998df.diff";
      hash = "sha256-ejMKFG/cJgoPlAFzVDPI4vIIL7URqaG06/IWdQ2NkhY=";
    })
    (fetchpatch {
      name = "thrift-fix-tests-OpenSSL3.patch"; # https://github.com/apache/thrift/pull/2760
      url = "https://github.com/apache/thrift/commit/eae3ac418f36c73833746bcd53e69ed8a12f0e1a.diff";
      hash = "sha256-0jlN4fo94cfGFUKcLFQgVMI/x7uxn5OiLiFk6txVPzs=";
    })
  ];

  cmakeFlags =
    [
      "-DBUILD_JAVASCRIPT:BOOL=OFF"
      "-DBUILD_NODEJS:BOOL=OFF"

      # FIXME: Fails to link in static mode with undefined reference to
      # `boost::unit_test::unit_test_main(bool (*)(), int, char**)'
      "-DBUILD_TESTING:BOOL=${if static then "OFF" else "ON"}"
    ]
    ++ lib.optionals static [
      "-DWITH_STATIC_LIB:BOOL=ON"
      "-DOPENSSL_USE_STATIC_LIBS=ON"
    ];

  disabledTests =
    [
      "PythonTestSSLSocket"
      "PythonThriftTNonblockingServer"
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

  checkPhase = ''
    runHook preCheck

    ${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH=$PWD/lib ctest -E "($(echo "$disabledTests" | tr " " "|"))"

    runHook postCheck
  '';

  enableParallelChecking = false;

  meta = with lib; {
    description = "Library for scalable cross-language services";
    mainProgram = "thrift";
    homepage = "https://thrift.apache.org/";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor ];
  };
}
