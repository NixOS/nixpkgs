{ stdenv
, fetchFromGitHub
, cmake
, bison
, boost
, libevent
, double-conversion
, libsodium
, fizz
, flex
, fmt_8
, folly
, glog
, gflags
, libiberty
, mvfst
, openssl
, lib
, wangle
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "fbthrift";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fbthrift";
    rev = "v${version}";
    sha256 = "sha256-iCiiKNDlfKm1Y4SGzcSP6o/OdiRRrj9UEawW6qpBpSY=";
  };

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isDarwin then "OFF" else "ON"}"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.14" # For aligned allocation
  ];

  buildInputs = [
    boost
    double-conversion
    fizz
    fmt_8
    folly
    glog
    gflags
    libevent
    libiberty
    mvfst
    openssl
    wangle
    zlib
    zstd
    libsodium
  ];

  meta = with lib; {
    description = "Facebook's branch of Apache Thrift";
    mainProgram = "thrift1";
    homepage = "https://github.com/facebook/fbthrift";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pierreis kylesferrazza ];
  };
}
