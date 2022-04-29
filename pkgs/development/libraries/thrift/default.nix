{ lib, stdenv, fetchurl, boost, zlib, libevent, openssl, python3, cmake, pkg-config
, bison, flex
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "thrift";
  version = "0.16.0";

  src = fetchurl {
    url = "https://archive.apache.org/dist/thrift/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-9GC1wcow2JGP+V6j62KRs5Uc9RhVNWYIjz8r6JgfYgk=";
  };

  # Workaround to make the python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [];

  nativeBuildInputs = [ cmake pkg-config bison flex ];
  buildInputs = [ boost zlib libevent openssl ]
    ++ lib.optionals (!static) [ (python3.withPackages (ps: [ps.twisted])) ];

  preConfigure = "export PY_PREFIX=$out";

  patches = [
    # ToStringTest.cpp is failing from some reason due to locale issue, this
    # doesn't disable all UnitTests as in Darwin.
    ./disable-failing-test.patch
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
    # tests that hang up in the darwin sandbox
    "SecurityTest"
    "SecurityFromBufferTest"
    "python_test"

    # tests that fail in the darwin sandbox when trying to use network
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
    maintainers = [ maintainers.bjornfor ];
  };
}
