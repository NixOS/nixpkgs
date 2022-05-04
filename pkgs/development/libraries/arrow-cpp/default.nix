{ stdenv
, lib
, fetchurl
, fetchFromGitHub
, fixDarwinDylibNames
, abseil-cpp
, autoconf
, aws-sdk-cpp
, boost
, brotli
, c-ares
, cmake
, crc32c
, curl
, flatbuffers
, gflags
, glog
, google-cloud-cpp
, grpc
, gtest
, jemalloc
, lz4
, minio
, ninja
, nlohmann_json
, openssl
, perl
, protobuf
, python3
, rapidjson
, re2
, snappy
, sqlite
, thrift
, tzdata
, utf8proc
, which
, zlib
, zstd
, enableShared ? !stdenv.hostPlatform.isStatic
, enableFlight ? true
, enableJemalloc ? !(stdenv.isAarch64 && stdenv.isDarwin)
  # boost/process is broken in 1.69 on darwin, but fixed in 1.70 and
  # non-existent in older versions
  # see https://github.com/boostorg/process/issues/55
, enableS3 ? (!stdenv.isDarwin) || (lib.versionOlder boost.version "1.69" || lib.versionAtLeast boost.version "1.70")
, enableGcs ? !stdenv.isDarwin # google-cloud-cpp is not supported on darwin
}:

assert lib.asserts.assertMsg
  ((enableS3 && stdenv.isDarwin) -> (lib.versionOlder boost.version "1.69" || lib.versionAtLeast boost.version "1.70"))
  "S3 on Darwin requires Boost != 1.69";

let
  arrow-testing = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-testing";
    rev = "634739c664433cec366b4b9a81d1e1044a8c5eda";
    hash = "sha256-r1WVgJJsI7v485L6Qb+5i7kFO4Tvxyk1T0JBb4og6pg=";
  };

  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "acd375eb86a81cd856476fca0f52ba6036a067ff";
    hash = "sha256-z/kmi+4dBO/dsVkJA4NgUoxl0pXi8RWIGvI8MGu/gcc=";
  };

in
stdenv.mkDerivation rec {
  pname = "arrow-cpp";
  version = "7.0.0";

  src = fetchurl {
    url =
      "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    hash = "sha256-6PSbFJoV7O9OQPz6sbh8ETxrHuGGAFwWnlzfldMamd4=";
  };
  sourceRoot = "apache-arrow-${version}/cpp";

  ${if enableJemalloc then "ARROW_JEMALLOC_URL" else null} = jemalloc.src;

  ARROW_MIMALLOC_URL = fetchFromGitHub {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    owner = "microsoft";
    repo = "mimalloc";
    rev = "v1.7.3";
    hash = "sha256-Ca877VitpWyKmZNHavqgewk/P+tyd2xHDNVqveKh87M=";
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
    ninja
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
    openssl
    protobuf
  ] ++ lib.optionals enableS3 [ aws-sdk-cpp openssl ]
  ++ lib.optionals enableGcs [
    abseil-cpp
    crc32c
    curl
    google-cloud-cpp
    nlohmann_json
  ];

  preConfigure = ''
    patchShebangs build-support/
    substituteInPlace "src/arrow/vendored/datetime/tz.cpp" \
      --replace 'discover_tz_dir();' '"${tzdata}/share/zoneinfo";'
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
    "-DARROW_ENGINE=ON"
    "-DARROW_FILESYSTEM=ON"
    "-DARROW_FLIGHT_SQL=${if enableFlight then "ON" else "OFF"}"
    "-DARROW_HDFS=ON"
    "-DARROW_IPC=ON"
    "-DARROW_JEMALLOC=${if enableJemalloc then "ON" else "OFF"}"
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
    "-DARROW_GCS=${if enableGcs then "ON" else "OFF"}"
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
        "TestS3FS.*"
        "TestS3FSGeneric.*"
      ];
    in
    lib.optionalString doInstallCheck "-${builtins.concatStringsSep ":" filteredTests}";
  installCheckInputs = [ perl which sqlite ] ++ lib.optional enableS3 minio;
  installCheckPhase =
    let
      excludedTests = lib.optionals stdenv.isDarwin [
        # Some plasma tests need to be patched to use a shorter AF_UNIX socket
        # path on Darwin. See https://github.com/NixOS/nix/pull/1085
        "plasma-external-store-tests"
        "plasma-client-tests"
      ] ++ [ "arrow-gcsfs-test" ];
    in
    ''
      runHook preInstallCheck

      ctest -L unittest \
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
  passthru = {
    inherit enableFlight enableJemalloc enableS3 enableGcs;
  };
}
