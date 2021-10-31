{ stdenv, lib, fetchurl, fetchFromGitHub, fixDarwinDylibNames
, autoconf, boost, brotli, cmake, flatbuffers, gflags, glog, gtest, lz4
, perl, python3, rapidjson, re2, snappy, thrift, tzdata , utf8proc, which
, zlib, zstd
, enableShared ? !stdenv.hostPlatform.isStatic
}:

let
  arrow-testing = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-testing";
    rev = "a60b715263d9bbf7e744527fb0c084b693f58043";
    hash = "sha256-Dz1dCV0m5Y24qzXdVaqrZ7hK3MRSb4GF0PXrjMAsjZU=";
  };

  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "d4d485956a643c693b5549e1a62d52ca61c170f1";
    hash = "sha256-GmOAS8gGhzDI0WzORMkWHRRUl/XBwmNen2d3VefZxxc=";
  };

in stdenv.mkDerivation rec {
  pname = "arrow-cpp";
  version = "6.0.0";

  src = fetchurl {
    url =
      "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    hash = "sha256-adJo+egtPr71la0b3IPUywKyDBgZRqaGMfZkXXwfepA=";
  };
  sourceRoot = "apache-arrow-${version}/cpp";

  ARROW_JEMALLOC_URL = fetchurl {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    url =
      "https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2";
    hash = "sha256-NDMOXOJ2CZ4uiVDZM121qHVomkxqVnUe87HYxTf4h/Y=";
  };

  ARROW_MIMALLOC_URL = fetchurl {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    url =
      "https://github.com/microsoft/mimalloc/archive/v1.7.2.tar.gz";
    hash = "sha256-sZEuNUVlpLaYQQ91g8D4OTSm27Ot5Uq33csVaTIJNr0=";
  };

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
    substituteInPlace "src/arrow/vendored/datetime/tz.cpp" \
      --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  cmakeFlags = [
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
    "-DARROW_BUILD_SHARED=${if enableShared then "ON" else "OFF"}"
    "-DARROW_BUILD_STATIC=${if enableShared then "OFF" else "ON"}"
    "-DARROW_BUILD_TESTS=ON"
    "-DARROW_VERBOSE_THIRDPARTY_BUILD=ON"
    "-DARROW_DEPENDENCY_SOURCE=SYSTEM"
    "-DThrift_SOURCE=AUTO" # search for Thrift using pkg-config (ThriftConfig.cmake requires OpenSSL and libevent)
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

  ARROW_XSIMD_URL = fetchurl {
    url = "https://github.com/xtensor-stack/xsimd/archive/aeec9c872c8b475dedd7781336710f2dd2666cb2.tar.gz";
    sha256 = "09kvl962c6b0wnb7pb2n9dhvkflzwalgq6gwwi8628fgi9n1x10a";
  };

  doInstallCheck = true;
  ARROW_TEST_DATA =
    if doInstallCheck then "${arrow-testing}/data" else null;
  PARQUET_TEST_DATA =
    if doInstallCheck then "${parquet-testing}/data" else null;
  GTEST_FILTER =
    if doInstallCheck then let
      # Upstream Issue: https://issues.apache.org/jira/browse/ARROW-11398
      filteredTests = lib.optionals stdenv.hostPlatform.isAarch64 [
        "TestFilterKernelWithNumeric/3.CompareArrayAndFilterRandomNumeric"
        "TestFilterKernelWithNumeric/7.CompareArrayAndFilterRandomNumeric"
        "TestCompareKernel.PrimitiveRandomTests"
      ];
    in "-${builtins.concatStringsSep ":" filteredTests}" else null;
  installCheckInputs = [ perl which ];
  installCheckPhase =
  let
    excludedTests = lib.optionals stdenv.isDarwin [
      # Some plasma tests need to be patched to use a shorter AF_UNIX socket
      # path on Darwin. See https://github.com/NixOS/nix/pull/1085
      "plasma-external-store-tests"
      "plasma-client-tests"
    ];
  in ''
    ctest -L unittest -V \
      --exclude-regex '^(${builtins.concatStringsSep "|" excludedTests})$'
  '';

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim veprbl cpcloud ];
  };
}
