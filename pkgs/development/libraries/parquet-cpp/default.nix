{ stdenv, symlinkJoin, fetchurl, arrow-cpp, boost, cmake, gtest, snappy, thrift, zlib }:

stdenv.mkDerivation rec {
  name = "parquet-cpp-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/apache/parquet-cpp/archive/apache-${name}.tar.gz";
    sha256 = "19nwqahc0igr0jfprbf2m86rmzz6zicw4z7b8z832wbsyc904wli";
  };

  patches = [ ./api.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  preConfigure = ''
    substituteInPlace cmake_modules/FindThrift.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
    substituteInPlace cmake_modules/FindSnappy.cmake --replace CMAKE_STATIC_LIBRARY CMAKE_SHARED_LIBRARY
  '';

  ARROW_HOME = arrow-cpp;
  THRIFT_HOME = thrift;
  GTEST_HOME = gtest;
  SNAPPY_HOME = symlinkJoin { name="snappy-wrap"; paths = [ snappy snappy.dev ]; };
  ZLIB_HOME = symlinkJoin { name="zlib-wrap"; paths = [ zlib.dev zlib.static ]; };

  cmakeFlags = [
    "-DPARQUET_BUILD_BENCHMARKS=OFF"
  ];

  meta = {
    description = "A C++ library to read and write the Apache Parquet columnar data format";
    homepage = http://parquet.apache.org;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
