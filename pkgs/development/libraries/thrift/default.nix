{ lib
, stdenv
, fetchurl
, fetchpatch
, boost
, zlib
, libevent
, openssl
, python3
, cmake
, pkg-config
, bison
, flex
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "thrift";
  version = "0.16.0";

  src = fetchurl {
    url = "https://archive.apache.org/dist/thrift/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-9GC1wcow2JGP+V6j62KRs5Uc9RhVNWYIjz8r6JgfYgk=";
  };

  # Workaround to make the Python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [];

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
  ];

  buildInputs = [
    boost
    libevent
    openssl
    zlib
  ] ++ lib.optionals (!static) [
    (python3.withPackages (ps: [ps.twisted]))
  ];

  postPatch = ''
    # Python 3.10 related failures:
    # SystemError: PY_SSIZE_T_CLEAN macro must be defined for '#' formats
    # AttributeError: module 'collections' has no attribute 'Hashable'
    substituteInPlace test/py/RunClientServer.py \
      --replace "'FastbinaryTest.py'," "" \
      --replace "'TestEof.py'," "" \
      --replace "'TestFrozen.py'," ""
  '';

  preConfigure = ''
    export PY_PREFIX=$out
  '';

  patches = [
    # ToStringTest.cpp is failing from some reason due to locale issue, this
    # doesn't disable all UnitTests as in Darwin.
    ./disable-failing-test.patch
    (fetchpatch {
      name = "tests-expired-certs.diff"; # https://github.com/apache/thrift/pull/2629
      url = "https://github.com/apache/thrift/commit/54765854873e19b8ba50a0ec8080dd92d8323851.diff";
      sha256 = "wnG2MjY0DtAhVcEdcxu77tDa4T9Xm2pMYZU2wXLx2OA=";
    })
    (fetchpatch {
      name = "setuptools-gte-62.1.0.patch";
      url = "https://github.com/apache/thrift/pull/2635/commits/c41ad9d5119e9bdae1746167e77e224f390f2c42.patch";
      hash = "sha256-FkErrg/6vXTomS4AsCsld7t+Iccc55ZiDaNjJ3W1km0=";
    })
  ];

  cmakeFlags = [
    "-DBUILD_JAVASCRIPT:BOOL=OFF"
    "-DBUILD_NODEJS:BOOL=OFF"

    # FIXME: Fails to link in static mode with undefined reference to
    # `boost::unit_test::unit_test_main(bool (*)(), int, char**)'
    "-DBUILD_TESTING:BOOL=${if static then "OFF" else "ON"}"
  ] ++ lib.optionals static [
    "-DWITH_STATIC_LIB:BOOL=ON"
    "-DOPENSSL_USE_STATIC_LIBS=ON"
  ];

  disabledTests = [
    "PythonTestSSLSocket"
  ] ++ lib.optionals stdenv.isDarwin [
    # Tests that hang up in the Darwin sandbox
    "SecurityTest"
    "SecurityFromBufferTest"
    "python_test"

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
    "PythonThriftTNonblockingServer"
  ];

  doCheck = !static;

  checkPhase = ''
    runHook preCheck

    ${lib.optionalString stdenv.isDarwin "DY"}LD_LIBRARY_PATH=$PWD/lib ctest -E "($(echo "$disabledTests" | tr " " "|"))"

    runHook postCheck
  '';

  enableParallelChecking = false;

  meta = with lib; {
    description = "Library for scalable cross-language services";
    homepage = "https://thrift.apache.org/";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor ];
  };
}
