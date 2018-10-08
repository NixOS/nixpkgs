{ stdenv, symlinkJoin, fetchurl, boost, brotli, cmake, double-conversion, flatbuffers, gflags, glog, gtest, lz4, python, rapidjson, snappy, thrift, zlib, zstd }:

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
    ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost double-conversion glog python.pkgs.python python.pkgs.numpy ];

  preConfigure = ''
    substituteInPlace cmake_modules/FindThrift.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindBrotli.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindGLOG.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindLz4.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindSnappy.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
  '';

  BROTLI_HOME = symlinkJoin { name="brotli-wrap"; paths = [ brotli.lib brotli.dev ]; };
  DOUBLE_CONVERSION_HOME = double-conversion;
  FLATBUFFERS_HOME = flatbuffers;
  GFLAGS_HOME = gflags;
  GLOG_HOME = glog;
  GTEST_HOME = gtest;
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

  meta = {
    description = "A  cross-language development platform for in-memory data";
    homepage = https://arrow.apache.org/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
