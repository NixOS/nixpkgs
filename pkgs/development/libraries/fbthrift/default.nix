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
, openssl
, lib
, wangle
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "fbthrift";
  version = "2023.03.20.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fbthrift";
    rev = "v${version}";
    sha256 = "sha256-jCgdo7jE5QlRK5f2S6XEVM4+TPWI//4DKG/fDMFzgzg=";
  };

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];

  cmakeFlags = lib.optionals stdenv.isDarwin [
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
    openssl
    wangle
    zlib
    zstd
    libsodium
  ];

  meta = with lib; {
    description = "Facebook's branch of Apache Thrift";
    homepage = "https://github.com/facebook/fbthrift";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pierreis kylesferrazza ];
  };
}
