{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, bzip2
, lz4
, snappy
, zlib
, zstd
, enableJemalloc ? false, jemalloc
, enableLite ? false
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "rocksdb";
  version = "7.4.5";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m1ZHyHYFDGTYpP4uAg4T75sLKoLwhEDJstWg7EXHNc8=";
  };

  nativeBuildInputs = [ cmake ninja ];

  propagatedBuildInputs = [ bzip2 lz4 snappy zlib zstd ];

  buildInputs = lib.optional enableJemalloc jemalloc;

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=deprecated-copy -Wno-error=pessimizing-move"
    + lib.optionalString stdenv.cc.isClang "-Wno-error=unused-private-field -faligned-allocation";

  cmakeFlags = [
    "-DPORTABLE=1"
    "-DWITH_JEMALLOC=${if enableJemalloc then "1" else "0"}"
    "-DWITH_JNI=0"
    "-DWITH_BENCHMARK_TOOLS=0"
    "-DWITH_TESTS=1"
    "-DWITH_TOOLS=0"
    "-DWITH_BZ2=1"
    "-DWITH_LZ4=1"
    "-DWITH_SNAPPY=1"
    "-DWITH_ZLIB=1"
    "-DWITH_ZSTD=1"
    "-DWITH_GFLAGS=0"
    "-DUSE_RTTI=1"
    "-DROCKSDB_INSTALL_ON_WINDOWS=YES" # harmless elsewhere
    (lib.optional
        (stdenv.hostPlatform.isx86 && stdenv.hostPlatform.isLinux)
        "-DFORCE_SSE42=1")
    (lib.optional enableLite "-DROCKSDB_LITE=1")
    "-DFAIL_ON_WARNINGS=${if stdenv.hostPlatform.isMinGW then "NO" else "YES"}"
  ] ++ lib.optional (!enableShared) "-DROCKSDB_BUILD_SHARED=0";

  # otherwise "cc1: error: -Wformat-security ignored without -Wformat [-Werror=format-security]"
  hardeningDisable = lib.optional stdenv.hostPlatform.isWindows "format";

  meta = with lib; {
    homepage = "https://rocksdb.org";
    description = "A library that provides an embeddable, persistent key-value store for fast storage";
    changelog = "https://github.com/facebook/rocksdb/raw/v${version}/HISTORY.md";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ adev magenbluten ];
  };
}
