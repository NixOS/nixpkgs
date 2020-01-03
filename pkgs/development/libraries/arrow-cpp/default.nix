{ stdenv, lib, fetchurl, fetchFromGitHub, fixDarwinDylibNames, autoconf, boost
, brotli, cmake, double-conversion, flatbuffers, gflags, glog, gtest, lz4, perl
, python, rapidjson, snappy, thrift, uriparser, which, zlib, zstd
, enableShared ? true }:

let
  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "a277dc4e55ded3e3ea27dab1e4faf98c112442df";
    sha256 = "1yh5a8l4ship36hwmgmp2kl72s5ac9r8ly1qcs650xv2g9q7yhnq";
  };

in stdenv.mkDerivation rec {
  pname = "arrow-cpp";
  version = "0.15.1";

  src = fetchurl {
    url =
      "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    sha256 = "1jbghpppabsix2rkxbnh41inj9lcxfz4q94p96xzxshh4g3mhb4s";
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
    double-conversion
    flatbuffers
    gflags
    glog
    gtest
    lz4
    rapidjson
    snappy
    thrift
    uriparser
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
    "-DARROW_BUILD_TESTS=ON"
    "-DARROW_DEPENDENCY_SOURCE=SYSTEM"
    "-DARROW_PARQUET=ON"
    "-DARROW_PLASMA=ON"
    # Disable Python for static mode because openblas is currently broken there.
    "-DARROW_PYTHON=${if enableShared then "ON" else "OFF"}"
    "-Duriparser_SOURCE=SYSTEM"
  ] ++ lib.optionals (!enableShared) [
    "-DARROW_BUILD_SHARED=OFF"
    "-DARROW_TEST_LINKAGE=static"
    "-DOPENSSL_USE_STATIC_LIBS=ON"
  ] ++ lib.optional (!stdenv.isx86_64) "-DARROW_USE_SIMD=OFF";

  doInstallCheck = true;
  PARQUET_TEST_DATA =
    if doInstallCheck then "${parquet-testing}/data" else null;
  installCheckInputs = [ perl which ];
  installCheckPhase = (lib.optionalString stdenv.isDarwin ''
    for f in release/*test{,s}; do
      install_name_tool -add_rpath "$out"/lib  "$f"
    done
  '')
  + (let
    excludedTests = lib.optionals stdenv.isDarwin [
      # Some plasma tests need to be patched to use a shorter AF_UNIX socket
      # path on Darwin. See https://github.com/NixOS/nix/pull/1085
      "plasma-external-store-tests"
      "plasma-client-tests"
    ];
  in ''
    ctest -L unittest -V \
      --exclude-regex '^(${builtins.concatStringsSep "|" excludedTests})$'
  '');

  meta = {
    description = "A  cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tobim veprbl ];
  };
}
