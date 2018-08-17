{ stdenv, symlinkJoin, fetchurl, boost, brotli, cmake, flatbuffers, gtest, gflags, lz4, python, rapidjson, snappy, zlib, zstd }:

stdenv.mkDerivation rec {
  name = "arrow-cpp-${version}";
  version = "0.10.0";

  src = fetchurl {
    url = "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    sha256 = "0bc4krapz1kzdm16npzmgdz7zvg9lip6rnqbwph8vfn7zji0fcll";
  };

  sourceRoot = "apache-arrow-${version}/cpp";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost python.pkgs.python python.pkgs.numpy ];

  preConfigure = ''
    substituteInPlace cmake_modules/FindBrotli.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindLz4.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindSnappy.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
  '';

  BROTLI_HOME = symlinkJoin { name="brotli-wrap"; paths = [ brotli.lib brotli.dev ]; };
  FLATBUFFERS_HOME = flatbuffers;
  GTEST_HOME = gtest;
  GFLAGS_HOME = gflags;
  LZ4_HOME = symlinkJoin { name="lz4-wrap"; paths = [ lz4 lz4.dev ]; };
  RAPIDJSON_HOME = rapidjson;
  SNAPPY_HOME = symlinkJoin { name="snappy-wrap"; paths = [ snappy snappy.dev ]; };
  ZLIB_HOME = symlinkJoin { name="zlib-wrap"; paths = [ zlib.dev zlib.static ]; };
  ZSTD_HOME = zstd;

  cmakeFlags = [
    "-DARROW_PYTHON=ON"
  ];

  meta = {
    description = "A  cross-language development platform for in-memory data";
    homepage = https://arrow.apache.org/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
