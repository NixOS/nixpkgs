{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, bzip2
, lz4
, snappy
, zlib
, zstd
, enableLite ? false
}:

stdenv.mkDerivation rec {
  pname = "rocksdb";
  version = "6.10.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f2wqb6px812ijcivq3rsknqgkv01wblc6sd8wavhrw8qljgr3s1";
  };

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [ bzip2 lz4 snappy zlib zstd ];

  patches = [
    # Without this change private dependencies are exported.
    # Can be removed after the next release.
    # https://github.com/facebook/rocksdb/pull/6790
    (fetchpatch {
      url = "https://github.com/facebook/rocksdb/commit/07204837ce8d66e1e6e4893178f3fd040f9c1044.patch";
      sha256 = "17097ybkhy0i089zzkpvcj65c7g5skvjvdzi1k09x4i1d719wm39";
    })
  ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isGNU "-Wno-error=deprecated-copy -Wno-error=pessimizing-move";

  cmakeFlags = [
    "-DPORTABLE=1"
    "-DWITH_JEMALLOC=0"
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
    (stdenv.lib.optional
        (stdenv.hostPlatform.isx86 && stdenv.hostPlatform.isLinux)
        "-DFORCE_SSE42=1")
    (stdenv.lib.optional enableLite "-DROCKSDB_LITE=1")
    "-DFAIL_ON_WARNINGS=${if stdenv.hostPlatform.isMinGW then "NO" else "YES"}"
  ];

  # otherwise "cc1: error: -Wformat-security ignored without -Wformat [-Werror=format-security]"
  hardeningDisable = stdenv.lib.optional stdenv.hostPlatform.isWindows "format";

  meta = with stdenv.lib; {
    homepage = "https://rocksdb.org";
    description = "A library that provides an embeddable, persistent key-value store for fast storage";
    license = licenses.asl20;
    maintainers = with maintainers; [ adev magenbluten ];
  };
}
