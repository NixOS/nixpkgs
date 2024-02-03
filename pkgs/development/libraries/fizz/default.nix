{ stdenv
, fetchFromGitHub
, cmake
, boost
, libevent
, double-conversion
, glog
, lib
, fmt_8
, zstd
, gflags
, libiberty
, openssl
, folly
, libsodium
, gtest
, zlib
}:

stdenv.mkDerivation rec {
  pname = "fizz";
  version = "2023.03.20.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fizz";
    rev = "refs/tags/v${version}";
    hash = "sha256-oBdTj7IPlmtF5rEgDVN/wwa0ZxkN6h2QMN3PQB0nCgQ=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeDir = "../fizz";

  cmakeFlags = [ "-Wno-dev" ]
    ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.14" # For aligned allocation
  ];

  NIX_LDFLAGS = "-lz";

  buildInputs = [
    fmt_8
    boost
    double-conversion
    folly
    glog
    gflags
    gtest
    libevent
    libiberty
    libsodium
    openssl
    zlib
    zstd
  ];

  meta = with lib; {
    description = "C++14 implementation of the TLS-1.3 standard";
    homepage = "https://github.com/facebookincubator/fizz";
    changelog = "https://github.com/facebookincubator/fizz/releases/tag/v${version}";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pierreis kylesferrazza ];
  };
}
