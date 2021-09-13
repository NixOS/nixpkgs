{ autoconf
, boost
, brotli
, cmake
, enableShared ? !stdenv.hostPlatform.isStatic
, fetchFromGitHub
, fetchurl
, fixDarwinDylibNames
, flatbuffers
, gflags
, glog
, gtest
, lib
, lz4
, perl
, python3
, rapidjson
, re2
, snappy
, stdenv
, thrift
, utf8proc
, which
, xsimd
, zlib
, zstd
, arrow-testing
, parquet-testing
, arrow-jemalloc
, arrow-mimalloc
, version
, srcHash
, ...
}:

stdenv.mkDerivation rec {
  inherit version;
  pname = "arrow-cpp";

  src = fetchurl {
    url =
      "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    hash = srcHash;
  };
  sourceRoot = "apache-arrow-${version}/cpp";

  ARROW_JEMALLOC_URL = arrow-jemalloc;
  ARROW_MIMALLOC_URL = arrow-mimalloc;

  patches = [
    # patch to fix python-test
    ./darwin.patch
  ];

  nativeBuildInputs = [
    cmake
    autoconf # for vendored jemalloc
    flatbuffers
  ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = [
    boost
    brotli
    flatbuffers
    gflags
    glog
    gtest
    lz4
    rapidjson
    re2
    snappy
    thrift
    utf8proc
    zlib
    zstd
  ] ++ lib.optionals enableShared [
    python3.pkgs.python
    python3.pkgs.numpy
  ];

  preConfigure = ''
    patchShebangs build-support/
  '';

  cmakeFlags = [
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
    "-DARROW_BUILD_SHARED=${if enableShared then "ON" else "OFF"}"
    "-DARROW_BUILD_STATIC=${if enableShared then "OFF" else "ON"}"
    "-DARROW_BUILD_TESTS=ON"
    "-DARROW_VERBOSE_THIRDPARTY_BUILD=ON"
    "-DARROW_DEPENDENCY_SOURCE=SYSTEM"
    "-DARROW_DEPENDENCY_USE_SHARED=${if enableShared then "ON" else "OFF"}"
    "-DARROW_COMPUTE=ON"
    "-DARROW_CSV=ON"
    "-DARROW_DATASET=ON"
    "-DARROW_JSON=ON"
    "-DARROW_PLASMA=ON"
    # Disable Python for static mode because openblas is currently broken there.
    "-DARROW_PYTHON=${if enableShared then "ON" else "OFF"}"
    "-DARROW_USE_GLOG=ON"
    "-DARROW_WITH_BROTLI=ON"
    "-DARROW_WITH_LZ4=ON"
    "-DARROW_WITH_SNAPPY=ON"
    "-DARROW_WITH_UTF8PROC=ON"
    "-DARROW_WITH_ZLIB=ON"
    "-DARROW_WITH_ZSTD=ON"
    "-DARROW_MIMALLOC=ON"
    # Parquet options:
    "-DARROW_PARQUET=ON"
    "-DPARQUET_BUILD_EXECUTABLES=ON"
  ] ++ lib.optionals (!enableShared) [
    "-DARROW_TEST_LINKAGE=static"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # needed for tests
    "-DCMAKE_INSTALL_RPATH=@loader_path/../lib" # needed for tools executables
  ] ++ lib.optional (!stdenv.isx86_64) "-DARROW_USE_SIMD=OFF";

  ARROW_XSIMD_URL = xsimd.src;

  doInstallCheck = true;
  ARROW_TEST_DATA =
    if doInstallCheck then "${arrow-testing}/data" else null;
  PARQUET_TEST_DATA =
    if doInstallCheck then "${parquet-testing}/data" else null;
  GTEST_FILTER =
    if doInstallCheck then
      let
        # Upstream Issue: https://issues.apache.org/jira/browse/ARROW-11398
        filteredTests = lib.optionals stdenv.hostPlatform.isAarch64 [
          "TestFilterKernelWithNumeric/3.CompareArrayAndFilterRandomNumeric"
          "TestFilterKernelWithNumeric/7.CompareArrayAndFilterRandomNumeric"
          "TestCompareKernel.PrimitiveRandomTests"
        ];
      in
      "-${builtins.concatStringsSep ":" filteredTests}" else null;
  installCheckInputs = [ perl which ];
  installCheckPhase =
    let
      excludedTests = lib.optionals stdenv.isDarwin [
        # Some plasma tests need to be patched to use a shorter AF_UNIX socket
        # path on Darwin. See https://github.com/NixOS/nix/pull/1085
        "plasma-external-store-tests"
        "plasma-client-tests"
      ];
    in
    ''
      ctest -L unittest -V \
        --exclude-regex '^(${builtins.concatStringsSep "|" excludedTests})$'
    '';

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim veprbl ];
  };
}
