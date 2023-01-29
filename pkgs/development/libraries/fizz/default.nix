{ lib
, stdenv
, fetchFromGitHub
, cmake
, folly
, fmt
, boost
, openssl
, glog
, double-conversion
, libsodium
, zlib
, zstd
, libevent
, xz
, snappy
, libunwind
, libiberty
, jemalloc
}:

stdenv.mkDerivation rec {
  pname = "fizz";
  version = "2023.01.23.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A0z/sWmqsgooDk+8OrSTJp4AeHJuBRKzWMLu0AwTdpQ=";
  };

  sourceRoot = "source/fizz";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    folly
    fmt
    boost
    openssl
    glog
    double-conversion
    libsodium
    zlib
    zstd
    libevent
    xz
    snappy
    libiberty
    libunwind
  ] ++ lib.optional stdenv.isLinux jemalloc;

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "C++14 implementation of the TLS-1.3 standard";
    homepage = "https://github.com/facebookincubator/fizz";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ candyc1oud ];
  };
}
