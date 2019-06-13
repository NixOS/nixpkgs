{ stdenv, fetchurl, fetchFromGitHub, autoconf, boost, brotli, cmake, double-conversion, flatbuffers, gflags, glog, gtest, lz4, perl, python, rapidjson, snappy, thrift, uriparser, which, zlib, zstd }:

let
  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "8991d0b58d5a59925c87dd2a0bdb59a5a4a16bd4";
    sha256 = "00js5d1s98y3ianrvh1ggrd157yfmia4g55jx9xmfcz4a8mcbawx";
  };

  # Enable non-bundled uriparser
  # Introduced in https://github.com/apache/arrow/pull/4092
  Finduriparser_cmake = fetchurl {
    url = https://raw.githubusercontent.com/apache/arrow/af4f52961209a5f1b43a19483536285c957e3bed/cpp/cmake_modules/Finduriparser.cmake;
    sha256 = "1cylrw00n2nkc2c49xk9j3rrza351rpravxgpw047vimcw0sk93s";
  };
in

stdenv.mkDerivation rec {
  name = "arrow-cpp-${version}";
  version = "0.13.0";

  src = fetchurl {
    url = "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    sha256 = "06irh5zx6lc7jjf6hpz1vzk0pvbdx08lcirc8cp8ksb8j7fpfamc";
  };

  sourceRoot = "apache-arrow-${version}/cpp";

  patches = [
    # patch to fix python-test
    ./darwin.patch
    ];

  nativeBuildInputs = [ cmake autoconf /* for vendored jemalloc */ ];
  buildInputs = [
    boost brotli double-conversion flatbuffers gflags glog gtest lz4 rapidjson
    snappy thrift uriparser zlib zstd python.pkgs.python python.pkgs.numpy
  ];

  preConfigure = ''
    substituteInPlace cmake_modules/FindLz4.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY

    cp ${Finduriparser_cmake} cmake_modules/Finduriparser.cmake

    patchShebangs build-support/

    # Fix build for ARROW_USE_SIMD=OFF
    # https://jira.apache.org/jira/browse/ARROW-5007
    sed -i src/arrow/util/sse-util.h -e '1i#include "arrow/util/logging.h"'
    sed -i src/arrow/util/neon-util.h -e '1i#include "arrow/util/logging.h"'
  '';

  cmakeFlags = [
    "-DARROW_BUILD_TESTS=ON"
    "-DARROW_DEPENDENCY_SOURCE=SYSTEM"
    "-DARROW_PARQUET=ON"
    "-DARROW_PYTHON=ON"
    "-Duriparser_SOURCE=SYSTEM"
  ] ++ stdenv.lib.optional (!stdenv.isx86_64) "-DARROW_USE_SIMD=OFF";

  doInstallCheck = true;
  PARQUET_TEST_DATA = if doInstallCheck then "${parquet-testing}/data" else null;
  installCheckInputs = [ perl which ];
  installCheckPhase = (stdenv.lib.optionalString stdenv.isDarwin ''
    for f in release/*-test; do
      install_name_tool -add_rpath "$out"/lib  "$f"
    done
  '') + ''
    ctest -L unittest -V
  '';

  meta = {
    description = "A  cross-language development platform for in-memory data";
    homepage = https://arrow.apache.org/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
