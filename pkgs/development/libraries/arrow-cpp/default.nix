{ stdenv, lib, fetchurl, fetchFromGitHub, fetchpatch, fixDarwinDylibNames
, autoconf, boost, brotli, cmake, flatbuffers, gflags, glog, gtest, lz4
, perl, python3, rapidjson, snappy, thrift, utf8proc, which, zlib, zstd
, enableShared ? true }:

let
  arrow-testing = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-testing";
    rev = "860376d4e586a3ac34ec93089889da624ead6c2a";
    sha256 = "16k3lz4ji4y3qcjhr765q14jwwlac8iqscwndwd8ll3zr0vy69b0";
  };

  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "d914f9d289488c7db1759d7a88a4a1b8f062c7dd";
    sha256 = "0xj3ynck2wv6l70xnmvs13bz1jycqjrl5k4lwhhwgag338048als";
  };

in stdenv.mkDerivation rec {
  pname = "arrow-cpp";
  version = "2.0.0";

  src = fetchurl {
    url =
      "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    sha256 = "1ghzqw0rx4rxa2d7i76y3szisv0bd9cl7vzadbc41cvvhk6440xy";
  };
  sourceRoot = "apache-arrow-${version}/cpp";

  ARROW_JEMALLOC_URL = fetchurl {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    url =
      "https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2";
    sha256 = "1xl7z0vwbn5iycg7amka9jd6hxd8nmfk7nahi4p9w2bnw9f0wcrl";
  };

  ARROW_MIMALLOC_URL = fetchurl {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    url =
      "https://github.com/microsoft/mimalloc/archive/v1.6.4.tar.gz";
    sha256 = "1b8av0974q70alcmaw5cwzbn6n9blnpmj721ik1qwmbbwwd6nqgs";
  };

  patches = [
    # patch to fix python-test
    ./darwin.patch
  ];

  nativeBuildInputs = [
    cmake
    autoconf # for vendored jemalloc
    flatbuffers
  ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = [
    boost
    brotli
    flatbuffers
    gflags
    glog
    gtest
    lz4
    rapidjson
    snappy
    thrift
    utf8proc
    zlib
    zstd
  ] ++ lib.optionals enableShared [
    python3.pkgs.python
    python3.pkgs.numpy
  ];

  preConfigure = ''
    patchShebangs build-support/
  '';

  cmakeFlags = [
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
    "-DARROW_BUILD_SHARED=${if enableShared then "ON" else "OFF"}"
    "-DARROW_BUILD_STATIC=${if enableShared then "OFF" else "ON"}"
    "-DARROW_BUILD_TESTS=ON"
    "-DARROW_VERBOSE_THIRDPARTY_BUILD=ON"
    "-DARROW_DEPENDENCY_SOURCE=SYSTEM"
    "-DARROW_DEPENDENCY_USE_SHARED=${if enableShared then "ON" else "OFF"}"
    "-DARROW_PLASMA=ON"
    # Disable Python for static mode because openblas is currently broken there.
    "-DARROW_PYTHON=${if enableShared then "ON" else "OFF"}"
    "-DARROW_USE_GLOG=ON"
    "-DARROW_WITH_BROTLI=ON"
    "-DARROW_WITH_LZ4=ON"
    "-DARROW_WITH_SNAPPY=ON"
    "-DARROW_WITH_UTF8PROC=ON"
    "-DARROW_WITH_ZLIB=ON"
    "-DARROW_WITH_ZSTD=ON"
    "-DARROW_MIMALLOC=ON"
    # Parquet options:
    "-DARROW_PARQUET=ON"
    "-DPARQUET_BUILD_EXECUTABLES=ON"
  ] ++ lib.optionals (!enableShared) [
    "-DARROW_TEST_LINKAGE=static"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # needed for tests
    "-DCMAKE_INSTALL_RPATH=@loader_path/../lib" # needed for tools executables
  ] ++ lib.optional (!stdenv.isx86_64) "-DARROW_USE_SIMD=OFF";

  doInstallCheck = true;
  ARROW_TEST_DATA =
    if doInstallCheck then "${arrow-testing}/data" else null;
  PARQUET_TEST_DATA =
    if doInstallCheck then "${parquet-testing}/data" else null;
  installCheckInputs = [ perl which ];
  installCheckPhase =
  let
    excludedTests = lib.optionals stdenv.isDarwin [
      # Some plasma tests need to be patched to use a shorter AF_UNIX socket
      # path on Darwin. See https://github.com/NixOS/nix/pull/1085
      "plasma-external-store-tests"
      "plasma-client-tests"
    ];
  in ''
    ctest -L unittest -V \
      --exclude-regex '^(${builtins.concatStringsSep "|" excludedTests})$'
  '';

  meta = {
    description = "A  cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tobim veprbl ];
  };
}
