{ stdenv
, fetchFromGitHub
, cmake
, boost
, libevent
, double-conversion
, glog
, gflags
, libiberty
, lz4
, lzma
, zlib
, jemalloc
, openssl
, pkg-config
, libunwind
, fmt
}:

stdenv.mkDerivation (rec {
  pname = "folly";
  version = "2020.09.28.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "1ry2nqfavcbz0jvsqw71105gbxm5hpmdi2k1w155m957jrv3n5vg";
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
    lzma
    zlib
    jemalloc
    libunwind
    fmt
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  meta = with stdenv.lib; {
    description = "An open-source C++ library developed and used at Facebook";
    homepage = "https://github.com/facebook/folly";
    license = licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ abbradar pierreis ];
  };
} // stdenv.lib.optionalAttrs stdenv.isDarwin {
  LDFLAGS = "-ljemalloc";
})
