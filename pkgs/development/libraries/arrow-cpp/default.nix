{ stdenv
, lib
, fetchurl
, fetchFromGitHub
, fixDarwinDylibNames
, autoconf
, aws-sdk-cpp
, boost
, brotli
, c-ares
, cmake
, flatbuffers
, gflags
, glog
, grpc
, gtest
, jemalloc
, libnsl
, lz4
, minio
, openssl
, perl
, protobuf
, python3
, rapidjson
, re2
, snappy
, thrift
, tzdata
, utf8proc
, which
, zlib
, zstd
, enableShared ? !stdenv.hostPlatform.isStatic
, enableFlight ? !stdenv.isDarwin # libnsl is not supported on darwin
, enableS3 ? true
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

in
stdenv.mkDerivation rec {
  pname = "arrow-cpp";
  version = "6.0.0";

  src = fetchurl {
    url =
      "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    hash = "sha256-adJo+egtPr71la0b3IPUywKyDBgZRqaGMfZkXXwfepA=";
  };
  sourceRoot = "apache-arrow-${version}/cpp";

  ARROW_JEMALLOC_URL = jemalloc.src;

  ARROW_MIMALLOC_URL = fetchFromGitHub {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    owner = "microsoft";
    repo = "mimalloc";
    rev = "v1.7.2";
    hash = "sha256-yHupYFgC8mJuLUSpuEAfwF7l6Ue4EiuO1Q4qN4T6wWc=";
  };

  ARROW_XSIMD_URL = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = "aeec9c872c8b475dedd7781336710f2dd2666cb2";
    hash = "sha256-vWKdJkieKhaxyAJhijXUmD7NmNvMWd79PskQojulA1w=";
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
  ] ++ lib.optionals enableFlight [
    grpc
    libnsl
    openssl
    protobuf
  ] ++ lib.optionals enableS3 [ aws-sdk-cpp openssl ];

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
    "-DARROW_FLIGHT=${if enableFlight then "ON" else "OFF"}"
    "-DARROW_S3=${if enableS3 then "ON" else "OFF"}"
  ] ++ lib.optionals (!enableShared) [
    "-DARROW_TEST_LINKAGE=static"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # needed for tests
    "-DCMAKE_INSTALL_RPATH=@loader_path/../lib" # needed for tools executables
  ] ++ lib.optional (!stdenv.isx86_64) "-DARROW_USE_SIMD=OFF"
  ++ lib.optional enableS3 "-DAWSSDK_CORE_HEADER_FILE=${aws-sdk-cpp}/include/aws/core/Aws.h";

  doInstallCheck = true;
  ARROW_TEST_DATA = lib.optionalString doInstallCheck "${arrow-testing}/data";
  PARQUET_TEST_DATA = lib.optionalString doInstallCheck "${parquet-testing}/data";
  GTEST_FILTER =
    let
      # Upstream Issue: https://issues.apache.org/jira/browse/ARROW-11398
      filteredTests = lib.optionals stdenv.hostPlatform.isAarch64 [
        "TestFilterKernelWithNumeric/3.CompareArrayAndFilterRandomNumeric"
        "TestFilterKernelWithNumeric/7.CompareArrayAndFilterRandomNumeric"
        "TestCompareKernel.PrimitiveRandomTests"
      ] ++ lib.optionals enableS3 [
        "S3OptionsTest.FromUri"
        "S3RegionResolutionTest.NonExistentBucket"
        "S3RegionResolutionTest.PublicBucket"
        "S3RegionResolutionTest.RestrictedBucket"
        "TestMinioServer.Connect"
        "TestS3FS.OpenOutputStreamBackgroundWrites"
        "TestS3FS.OpenOutputStreamDestructorBackgroundWrites"
        "TestS3FS.OpenOutputStreamDestructorSyncWrite"
        "TestS3FS.OpenOutputStreamDestructorSyncWrites"
        "TestS3FS.OpenOutputStreamMetadata"
        "TestS3FS.OpenOutputStreamSyncWrites"
        "TestS3FSGeneric.*"
      ];
    in
    lib.optionalString doInstallCheck "-${builtins.concatStringsSep ":" filteredTests}";
  installCheckInputs = [ perl which ] ++ lib.optional enableS3 minio;
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
      runHook preInstallCheck

      ctest -L unittest -V \
        --exclude-regex '^(${builtins.concatStringsSep "|" excludedTests})$'

      runHook postInstallCheck
    '';

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim veprbl cpcloud ];
  };
}
