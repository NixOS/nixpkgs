{ stdenv, fetchFromGitHub, fetchpatch
, cmake
, bzip2, lz4, snappy, zlib, zstd
, enableLite ? false
}:

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

  patches = [
    (fetchpatch {
      url = "https://github.com/facebook/rocksdb/commit/6a376fc709e9d289c1be4a7d479eb460cd27a87f.diff";
      sha256 = "1rsc1nagwica0krfkvjv21jhgfxpl9359aqqaaxqfnbvfds43ljs";
    })
    (fetchpatch {
      url = "https://github.com/facebook/rocksdb/commit/3b860886c01bd880158e9a63ff970dfe9aa966cb.diff";
      sha256 = "1b6p2ghmbawcafv4w9m8g4xv1f9xjijdbm4hj4rg3f8mylqcv7i1";
    })
    (fetchpatch {
      url = "https://github.com/facebook/rocksdb/commit/31ac949de35c0e21440f851a6811304de964d22a.diff";
      sha256 = "1316cw74cdfll51gacr9qshrwdg4j8w9n75bvfxiir8v57xaipzj";
    })
    (fetchpatch {
      url = "https://github.com/facebook/rocksdb/commit/c585211cec1211ad9b977211ba5aa69853a20348.diff";
      sha256 = "01kwnm0r4msc3b6fwx2j14p68ii7z2d6abig2093izcvbm6hq6p1";
    })
  ];

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
