{ lib, stdenv
, fetchFromGitHub
, boost
, cmake
, double-conversion
, fetchpatch
, fmt_8
, gflags
, glog
, libevent
, libiberty
, libunwind
, lz4
, openssl
, pkg-config
, xz
, zlib
, zstd
, jemalloc
, follyMobile ? false
}:

stdenv.mkDerivation rec {
  pname = "folly";
  version = "2022.07.04.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "sha256-TUtqwFBxYMnjXpygwXYWK7FNvTPL4a7T+rn1TMtUIPc=";
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
    libunwind
    fmt_8
    zstd
  ] ++ lib.optional stdenv.isLinux jemalloc;

  # jemalloc headers are required in include/folly/portability/Malloc.h
  propagatedBuildInputs = lib.optional stdenv.isLinux jemalloc;

  NIX_CFLAGS_COMPILE = [ "-DFOLLY_MOBILE=${if follyMobile then "1" else "0"}" "-fpermissive" ];
  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  meta = with lib; {
    description = "An open-source C++ library developed and used at Facebook";
    homepage = "https://github.com/facebook/folly";
    license = licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
    maintainers = with maintainers; [ abbradar pierreis ];
  };
}
