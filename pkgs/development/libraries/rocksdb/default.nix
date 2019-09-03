{ stdenv, fetchFromGitHub, lib, bzip2, cmake, lz4, snappy, zlib, zstd, enableLite ? false }:

stdenv.mkDerivation rec {
  pname = "rocksdb";
  version = "6.2.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wz9rfj8gk6gyabh9anl67fqm5dw2z866y1a0k0j2lmcaag537r2";
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
