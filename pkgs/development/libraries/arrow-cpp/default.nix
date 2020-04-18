{ stdenv, lib, fetchurl, fetchFromGitHub, fetchpatch, fixDarwinDylibNames, autoconf, boost
, brotli, cmake, flatbuffers, gflags, glog, gtest, lz4, perl
, python, rapidjson, snappy, thrift, which, zlib, zstd
, enableShared ? true }:

let
  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "46c9e977f58f6c5ef1b81f782f3746b3656e5a8c";
    sha256 = "1z2s6zh58nf484s0yraw7b1aqgx66dn2wzp1bzv9ndq03msklwly";
  };

in stdenv.mkDerivation rec {
  pname = "arrow-cpp";
  version = "0.16.0";

  src = fetchurl {
    url =
      "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    sha256 = "1xdp1yni9i1cpml326s78qql1g832m800h7zjlqmk89983g94696";
  };

  sourceRoot = "apache-arrow-${version}/cpp";

  ARROW_JEMALLOC_URL = fetchurl {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    url =
      "https://github.com/jemalloc/jemalloc/releases/download/5.2.0/jemalloc-5.2.0.tar.bz2";
    sha256 = "1d73a5c5qdrwck0fa5pxz0myizaf3s9alsvhiqwrjahdlr29zgkl";
  };

  patches = [
    # patch to fix python-test
    ./darwin.patch
    # Adjust CMake target names to make -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON work.
    # Remove this when updating to the next version.
    (fetchpatch {
      name = "arrow-use-upstream-cmake-target-names.patch";
      url = "https://github.com/apache/arrow/commit/396861b38d2f4e805db7c2ecd2c96fff0ca2678b.patch";
      sha256 = "0ki7nx858374anvwyi4szz5hgnnzv4fghdd05c38bzry9rfljgb1";
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
    python.pkgs.python
    python.pkgs.numpy
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
    # Parquet options:
    "-DARROW_PARQUET=ON"
    "-DPARQUET_BUILD_EXECUTABLES=ON"
    "-DTHRIFT_COMPILER=${thrift}/bin/thrift"
    "-DTHRIFT_VERSION=${thrift.version}"
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
