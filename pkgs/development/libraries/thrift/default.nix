{ lib, stdenv, fetchurl, boost, zlib, libevent, openssl, python, cmake, pkg-config
, bison, flex, twisted
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "thrift";
  version = "0.14.1";

  src = fetchurl {
    url = "https://archive.apache.org/dist/thrift/${version}/${pname}-${version}.tar.gz";
    sha256 = "198c855mjy5byqfb941hiyq2j37baz63f0wcfy4vp8y8v4f5xnhk";
  };

  # Workaround to make the python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [];

  nativeBuildInputs = [ cmake pkg-config bison flex ];
  buildInputs = [ boost zlib libevent openssl ]
    ++ lib.optionals (!static) [ python twisted ];

  preConfigure = "export PY_PREFIX=$out";

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
    homepage = "http://thrift.apache.org/";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
