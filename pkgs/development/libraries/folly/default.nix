{ lib
, stdenv
, fetchFromGitHub
, boost
, cmake
, double-conversion
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

# for passthru.tests
, python3
, watchman
}:

stdenv.mkDerivation rec {
  pname = "folly";
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "sha256-INvWTw27fmVbKQIT9ebdRGMCOIzpc/NepRN2EnKLJx0=";
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
  ] ++ lib.optional stdenv.hostPlatform.isLinux jemalloc;

  # jemalloc headers are required in include/folly/portability/Malloc.h
  propagatedBuildInputs = lib.optional stdenv.hostPlatform.isLinux jemalloc;

  env.NIX_CFLAGS_COMPILE = toString [ "-DFOLLY_MOBILE=${if follyMobile then "1" else "0"}" "-fpermissive" ];
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"

    # temporary hack until folly builds work on aarch64,
    # see https://github.com/facebook/folly/issues/1880
    "-DCMAKE_LIBRARY_ARCHITECTURE=${if stdenv.hostPlatform.isx86_64 then "x86_64" else "dummy"}"

    # ensure correct dirs in $dev/lib/pkgconfig/libfolly.pc
    # see https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ] ++ lib.optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13"
  ];

  # split outputs to reduce downstream closure sizes
  outputs = [ "out" "dev" ];

  # patch prefix issues again
  # see https://github.com/NixOS/nixpkgs/issues/144170
  postFixup = ''
    substituteInPlace $dev/lib/cmake/${pname}/${pname}-targets-release.cmake  \
      --replace '$'{_IMPORT_PREFIX}/lib/ $out/lib/
  '';

  passthru = {
    # folly-config.cmake, will `find_package` these, thus there should be
    # a way to ensure abi compatibility.
    inherit boost;
    fmt = fmt_8;

    tests = {
      inherit watchman;
      inherit (python3.pkgs) django pywatchman;
    };
  };

  meta = with lib; {
    description = "Open-source C++ library developed and used at Facebook";
    homepage = "https://github.com/facebook/folly";
    license = licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
    maintainers = with maintainers; [ abbradar pierreis ];
  };
}
