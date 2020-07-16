{ stdenv, lib, fetchurl, fetchFromGitHub, fetchpatch, fixDarwinDylibNames, autoconf, boost
, brotli, cmake, flatbuffers, gflags, glog, gtest, lz4, perl
, python3, rapidjson, snappy, thrift, which, zlib, zstd
, enableShared ? true }:

let
  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "bcd9ebcf9204a346df47204fe21b85c8d0498816";
    sha256 = "0m16pqzbvxiaradq088q5ai6fwnz9srbap996397znwppvva479b";
  };

in stdenv.mkDerivation rec {
  pname = "arrow-cpp";
  version = "0.17.1";

  src = fetchurl {
    url =
      "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    sha256 = "18lyvbibfdw3w77cy5whbq7c6mshn5fg2bhvgw7v226a7cs1rifb";
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

  patches = [
    # patch to fix python-test
    ./darwin.patch

    # fix musl build
    (fetchpatch {
      url = "https://github.com/apache/arrow/commit/de4168786dfd8ab932f48801e0a7a6b8a370c19d.diff";
      sha256 = "1nl4y1rwdl0gn67v7l05ibc4lwkn6x7fhwbmslmm08cqmwfjsx3y";
      stripLen = 1;
    })

    # fix build for "ZSTD_SOURCE=SYSTEM"
    (fetchpatch {
      url = "https://github.com/apache/arrow/commit/13cb3dbded1928d2e96574895bebaf9098a4796d.diff";
      sha256 = "12z3ys47qp2x8f63lggiyj4xs2kmg804ri4xqysw5krbjz2hr6rb";
      stripLen = 1;
    })
  ] ++ lib.optionals (!enableShared) [
    # The shared jemalloc lib is unused and breaks in static mode due to missing -fpic.
    ./jemalloc-disable-shared.patch
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
    zlib
    zstd
  ] ++ lib.optionals enableShared [
    python3.pkgs.python
    python3.pkgs.numpy
  ];

  preConfigure = ''
    substituteInPlace cmake_modules/FindLz4.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY

    patchShebangs build-support/
  '';

  cmakeFlags = [
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
    "-DARROW_BUILD_TESTS=ON"
    "-DARROW_DEPENDENCY_SOURCE=SYSTEM"
    "-DARROW_PLASMA=ON"
    # Disable Python for static mode because openblas is currently broken there.
    "-DARROW_PYTHON=${if enableShared then "ON" else "OFF"}"
    "-DARROW_USE_GLOG=ON"
    "-DARROW_WITH_BROTLI=ON"
    "-DARROW_WITH_LZ4=ON"
    "-DARROW_WITH_SNAPPY=ON"
    "-DARROW_WITH_ZLIB=ON"
    "-DARROW_WITH_ZSTD=ON"
    "-DARROW_ZSTD_USE_SHARED=${if enableShared then "ON" else "OFF"}"
    # Parquet options:
    "-DARROW_PARQUET=ON"
    "-DPARQUET_BUILD_EXECUTABLES=ON"
  ] ++ lib.optionals (!enableShared) [
    "-DARROW_BUILD_SHARED=OFF"
    "-DARROW_BOOST_USE_SHARED=OFF"
    "-DARROW_GFLAGS_USE_SHARED=OFF"
    "-DARROW_PROTOBUF_USE_SHARED=OFF"
    "-DARROW_TEST_LINKAGE=static"
    "-DOPENSSL_USE_STATIC_LIBS=ON"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # needed for tests
    "-DCMAKE_INSTALL_RPATH=@loader_path/../lib" # needed for tools executables
  ] ++ lib.optional (!stdenv.isx86_64) "-DARROW_USE_SIMD=OFF";

  doInstallCheck = true;
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
