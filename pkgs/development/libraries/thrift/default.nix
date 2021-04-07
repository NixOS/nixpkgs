{ stdenv, fetchurl, fetchpatch, boost, zlib, libevent, openssl, python, cmake, pkgconfig
, bison, flex, twisted, static ? false }:

stdenv.mkDerivation rec {
  pname = "thrift";
  version = "0.13.0";

  src = fetchurl {
    url = "https://archive.apache.org/dist/thrift/${version}/${pname}-${version}.tar.gz";
    sha256 = "0yai9c3bdsrkkjshgim7zk0i7malwfprg00l9774dbrkh2w4ilvs";
  };

  patches = [
    # Fix a failing test on darwin
    # https://issues.apache.org/jira/browse/THRIFT-4976
    (fetchpatch {
      url = "https://github.com/apache/thrift/commit/6701dbb8e89f6550c7843e9b75b118998df471c3.diff";
      sha256 = "14rqma2b2zv3zxkkl5iv9kvyp3zihvad6fdc2gcdqv37nqnswx9d";
    })
  ];

  # Workaround to make the python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost zlib libevent openssl python bison flex ]
    ++ stdenv.lib.optional (!static) twisted;

  preConfigure = "export PY_PREFIX=$out";

  cmakeFlags = [
    # FIXME: Fails to link in static mode with undefined reference to
    # `boost::unit_test::unit_test_main(bool (*)(), int, char**)'
    "-DBUILD_TESTING:BOOL=${if static then "OFF" else "ON"}"
  ] ++ stdenv.lib.optionals static [
    "-DWITH_STATIC_LIB:BOOL=ON"
    "-DOPENSSL_USE_STATIC_LIBS=ON"
  ];

  doCheck = !static;
  checkPhase = ''
    runHook preCheck

    ${stdenv.lib.optionalString stdenv.isDarwin "DY"}LD_LIBRARY_PATH=$PWD/lib ctest -E PythonTestSSLSocket

    runHook postCheck
  '';
  enableParallelChecking = false;

  meta = with stdenv.lib; {
    description = "Library for scalable cross-language services";
    homepage = "http://thrift.apache.org/";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
    knownVulnerabilities = [
      "CVE-2020-13949"
    ];
  };
}
