{ stdenv, symlinkJoin, fetchurl, fetchFromGitHub, boost, brotli, cmake, double-conversion, flatbuffers, gflags, glog, gtest, lz4, perl, python, rapidjson, snappy, thrift, which, zlib, zstd }:

let
  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "46ae2605c2de306f5740587107dcf333a527f2d1";
    sha256 = "07ps745gas2zcfmg56m3vwl63yyzmalnxwb5dc40vd004cx5hdik";
  };
in

stdenv.mkDerivation rec {
  name = "arrow-cpp-${version}";
  version = "0.11.0";

  src = fetchurl {
    url = "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    sha256 = "0pc5pqr0dbnx8s1ji102dhw9bbrsq3ml4ac3mmi2022yfyizlf0q";
  };

  sourceRoot = "apache-arrow-${version}/cpp";

  patches = [
    # fix ARROW-3467
    ./double-conversion_cmake.patch

    # patch to fix python-test
    ./darwin.patch

    # facebook/zstd#1385
    ./zstd136.patch
    ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost double-conversion glog python.pkgs.python python.pkgs.numpy ];

  preConfigure = ''
    substituteInPlace cmake_modules/FindThrift.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindBrotli.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindGLOG.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindLz4.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindSnappy.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY

    patchShebangs build-support/
  '';

  BROTLI_HOME = symlinkJoin { name="brotli-wrap"; paths = [ brotli.lib brotli.dev ]; };
  DOUBLE_CONVERSION_HOME = double-conversion;
  FLATBUFFERS_HOME = flatbuffers;
  GFLAGS_HOME = gflags;
  GLOG_HOME = glog;
  GTEST_HOME = symlinkJoin { name="gtest-wrap"; paths = [ gtest gtest.dev ]; };
  LZ4_HOME = symlinkJoin { name="lz4-wrap"; paths = [ lz4 lz4.dev ]; };
  RAPIDJSON_HOME = rapidjson;
  SNAPPY_HOME = symlinkJoin { name="snappy-wrap"; paths = [ snappy snappy.dev ]; };
  THRIFT_HOME = thrift;
  ZLIB_HOME = symlinkJoin { name="zlib-wrap"; paths = [ zlib zlib.dev ]; };
  ZSTD_HOME = zstd;

  cmakeFlags = [
    "-DARROW_PYTHON=ON"
    "-DARROW_PARQUET=ON"
  ];

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
