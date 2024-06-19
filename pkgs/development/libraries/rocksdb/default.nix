{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, bzip2
, lz4
, snappy
, zlib
, zstd
, windows
, enableJemalloc ? false
, jemalloc
, enableShared ? !stdenv.hostPlatform.isStatic
, sse42Support ? stdenv.hostPlatform.sse4_2Support
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocksdb";
  version = "9.2.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-Zifn5Gu/4h6TaEqSaWQ2mFdryeAarqbHWW3fKUGGFac=";
  };

  nativeBuildInputs = [ cmake ninja ];

  propagatedBuildInputs = [ bzip2 lz4 snappy zlib zstd ];

  buildInputs = lib.optional enableJemalloc jemalloc
    ++ lib.optional stdenv.hostPlatform.isMinGW windows.mingw_w64_pthreads;

  outputs = [
    "out"
    "tools"
  ];

 env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [
   "-faligned-allocation"
 ]);

  cmakeFlags = [
    "-DPORTABLE=1"
    "-DWITH_JEMALLOC=${if enableJemalloc then "1" else "0"}"
    "-DWITH_JNI=0"
    "-DWITH_BENCHMARK_TOOLS=0"
    "-DWITH_TESTS=1"
    "-DWITH_TOOLS=0"
    "-DWITH_CORE_TOOLS=1"
    "-DWITH_BZ2=1"
    "-DWITH_LZ4=1"
    "-DWITH_SNAPPY=1"
    "-DWITH_ZLIB=1"
    "-DWITH_ZSTD=1"
    "-DWITH_GFLAGS=0"
    "-DUSE_RTTI=1"
    "-DROCKSDB_INSTALL_ON_WINDOWS=YES" # harmless elsewhere
    (lib.optional sse42Support "-DFORCE_SSE42=1")
    "-DFAIL_ON_WARNINGS=NO"
  ] ++ lib.optional (!enableShared) "-DROCKSDB_BUILD_SHARED=0";

  # otherwise "cc1: error: -Wformat-security ignored without -Wformat [-Werror=format-security]"
  hardeningDisable = lib.optional stdenv.hostPlatform.isWindows "format";

  postPatch = lib.optionalString (lib.versionOlder finalAttrs.version "8") ''
    # Fix gcc-13 build failures due to missing <cstdint> and
    # <system_error> includes, fixed upstyream sice 8.x
    sed -e '1i #include <cstdint>' -i db/compaction/compaction_iteration_stats.h
    sed -e '1i #include <cstdint>' -i table/block_based/data_block_hash_index.h
    sed -e '1i #include <cstdint>' -i util/string_util.h
    sed -e '1i #include <cstdint>' -i include/rocksdb/utilities/checkpoint.h
  '' + lib.optionalString (lib.versionOlder finalAttrs.version "7") ''
    # Fix gcc-13 build failures due to missing <cstdint> and
    # <system_error> includes, fixed upstyream sice 7.x
    sed -e '1i #include <system_error>' -i third-party/folly/folly/synchronization/detail/ProxyLockable-inl.h
  '';

  preInstall = ''
    mkdir -p $tools/bin
    cp tools/{ldb,sst_dump}${stdenv.hostPlatform.extensions.executable} $tools/bin/
  '' + lib.optionalString stdenv.isDarwin ''
    ls -1 $tools/bin/* | xargs -I{} install_name_tool -change "@rpath/librocksdb.${lib.versions.major finalAttrs.version}.dylib" $out/lib/librocksdb.dylib {}
  '' + lib.optionalString (stdenv.isLinux && enableShared) ''
    ls -1 $tools/bin/* | xargs -I{} patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib {}
  '';

  # Old version doesn't ship the .pc file, new version puts wrong paths in there.
  postFixup = ''
    if [ -f "$out"/lib/pkgconfig/rocksdb.pc ]; then
      substituteInPlace "$out"/lib/pkgconfig/rocksdb.pc \
        --replace '="''${prefix}//' '="/'
    fi
  '';

  meta = with lib; {
    homepage = "https://rocksdb.org";
    description = "A library that provides an embeddable, persistent key-value store for fast storage";
    changelog = "https://github.com/facebook/rocksdb/raw/v${finalAttrs.version}/HISTORY.md";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ adev magenbluten ];
  };
})
