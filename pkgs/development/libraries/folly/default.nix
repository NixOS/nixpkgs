{ lib, stdenv
, fetchFromGitHub
, cmake
, boost
, libevent
, double-conversion
, glog
, gflags
, libiberty
, lz4
, xz
, zlib
, jemalloc
, openssl
, pkg-config
, libunwind
, fmt
}:

stdenv.mkDerivation (rec {
  pname = "folly";
  version = "2021.10.25.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "sha256-+di8Dzt5NRbqIydBR4sB6bUbQrZZ8URUosdP2JGQMec=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  # See CMake/folly-deps.cmake in the Folly source tree.
  buildInputs = [
    boost
    double-conversion
    glog
    gflags
    libevent
    libiberty
    openssl
    lz4
    xz
    zlib
    jemalloc
    libunwind
    fmt
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  meta = with lib; {
    description = "An open-source C++ library developed and used at Facebook";
    homepage = "https://github.com/facebook/folly";
    license = licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ abbradar pierreis ];
  };
} // lib.optionalAttrs stdenv.isDarwin {
  LDFLAGS = "-ljemalloc";
})
