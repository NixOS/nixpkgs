{ stdenv, fetchFromGitHub, fetchpatch
, cmake, ninja
, bzip2, lz4, snappy, zlib, zstd
, enableLite ? false
}:

stdenv.mkDerivation rec {
  pname = "rocksdb";
  version = "6.4.6";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s0n4p1b4jzmslz9d2xd4ajra0m6l9x26mjwlbgw0klxjggmy8qn";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ bzip2 lz4 snappy zlib zstd ];

  patches = [
    # https://github.com/facebook/rocksdb/pull/6076
    (fetchpatch {
      url = "https://github.com/facebook/rocksdb/commit/c0be4b2ff1a5393419673fab961cb9b09ba38752.diff";
      sha256 = "1f2wg9kqlmf2hiiihmbp8m5fr2wnn7896g6i9yg9hdgi40pw30w6";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "find_package(zlib " "find_package(ZLIB "
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isGNU "-Wno-error=deprecated-copy -Wno-error=pessimizing-move";

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
    "-DUSE_RTTI=1"
    "-DROCKSDB_INSTALL_ON_WINDOWS=YES" # harmless elsewhere
    (stdenv.lib.optional
        (stdenv.hostPlatform.isx86 && stdenv.hostPlatform.isLinux)
        "-DFORCE_SSE42=1")
    (stdenv.lib.optional enableLite "-DROCKSDB_LITE=1")
    "-DFAIL_ON_WARNINGS=${if stdenv.hostPlatform.isMinGW then "NO" else "YES"}"
  ];

  # otherwise "cc1: error: -Wformat-security ignored without -Wformat [-Werror=format-security]"
  hardeningDisable = stdenv.lib.optional stdenv.hostPlatform.isWindows "format";

  meta = with stdenv.lib; {
    homepage = https://rocksdb.org;
    description = "A library that provides an embeddable, persistent key-value store for fast storage";
    license = licenses.asl20;
    maintainers = with maintainers; [ adev magenbluten ];
  };
}
