{ stdenv, fetchFromGitHub, lib, bzip2, cmake, lz4, snappy, zlib, zstd, enableLite ? false }:

stdenv.mkDerivation rec {
  pname = "rocksdb";
  version = "6.2.4";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "v${version}";
    sha256 = "08077agbimm7738xrknkw6fjw9f8jv6x3igp8b5pmsj9l954ywma";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ bzip2 lz4 snappy zlib zstd ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "find_package(zlib " "find_package(ZLIB "
  '';

  cmakeFlags = [
    "-DPORTABLE=1"
    "-DWITH_JEMALLOC=0"
    "-DWITH_JNI=0"
    "-DWITH_TESTS=0"
    "-DWITH_TOOLS=0"
    "-DWITH_BZ2=1"
    "-DWITH_LZ4=1"
    "-DWITH_SNAPPY=1"
    "-DWITH_ZLIB=1"
    "-DWITH_ZSTD=1"
    "-DWITH_GFLAGS=0"
    (lib.optional
        (stdenv.hostPlatform.system == "i686-linux"
         || stdenv.hostPlatform.system == "x86_64-linux")
        "-DFORCE_SSE42=1")
    (lib.optional enableLite "-DROCKSDB_LITE=1")
  ];

  meta = with stdenv.lib; {
    homepage = https://rocksdb.org;
    description = "A library that provides an embeddable, persistent key-value store for fast storage";
    license = licenses.asl20;
    maintainers = with maintainers; [ adev magenbluten ];
  };
}
