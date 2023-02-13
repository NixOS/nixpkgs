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
  version = "2023.02.06.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fizz";
    rev = "v${version}";
    sha256 = "sha256-JwRoIiSumT1jw5/VX/TkxpTJbrmLLke27xH8UHtrs2c=";
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
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pierreis kylesferrazza ];
  };
}
