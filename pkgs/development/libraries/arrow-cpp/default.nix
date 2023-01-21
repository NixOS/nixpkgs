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
, crc32c
, curl
, flatbuffers
, gflags
, glog
, google-cloud-cpp
, grpc
, gtest
, libbacktrace
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
, enableJemalloc ? !stdenv.isDarwin
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
    name = "arrow-testing";
    owner = "apache";
    repo = "arrow-testing";
    rev = "00c483283433b4c02cb811f260dbe35414c806a4";
    hash = "sha256-x645DFowLk0e4JN2hI6asWlJlhN36vg5/eC3wTbFI2k=";
  };

  parquet-testing = fetchFromGitHub {
    name = "parquet-testing";
    owner = "apache";
    repo = "parquet-testing";
    rev = "e13af117de7c4f0a4d9908ae3827b3ab119868f3";
    hash = "sha256-rVI9zyk9IRDlKv4u8BeMb0HRdWLfCpqOlYCeUdA7BB8=";
  };

in
stdenv.mkDerivation rec {
  pname = "arrow-cpp";
  version = "10.0.1";

  src = fetchurl {
    url = "mirror://apache/arrow/arrow-${version}/apache-arrow-${version}.tar.gz";
    hash = "sha256-yBTgZwESoiwabsA6tCClKuI2qaQunkOMPL03835lj7M=";
  };
  sourceRoot = "apache-arrow-${version}/cpp";

  # versions are all taken from
  # https://github.com/apache/arrow/blob/apache-arrow-${version}/cpp/thirdparty/versions.txt

  # jemalloc: arrow uses a custom prefix to prevent default allocator symbol
  # collisions as well as custom build flags
  ${if enableJemalloc then "ARROW_JEMALLOC_URL" else null} = fetchurl {
    url = "https://github.com/jemalloc/jemalloc/releases/download/5.3.0/jemalloc-5.3.0.tar.bz2";
    hash = "sha256-LbgtHnEZ3z5xt2QCGbbf6EeJvAU3mDw7esT3GJrs/qo=";
  };

  # mimalloc: arrow uses custom build flags for mimalloc
  ARROW_MIMALLOC_URL = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    rev = "v2.0.6";
    hash = "sha256-u2ITXABBN/dwU+mCIbL3tN1f4c17aBuSdNTV+Adtohc=";
  };

  ARROW_XSIMD_URL = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = "9.0.1";
    hash = "sha256-onALN6agtrHWigtFlCeefD9CiRZI4Y690XTzy2UDnrk=";
  };

  ARROW_SUBSTRAIT_URL = fetchFromGitHub {
    owner = "substrait-io";
    repo = "substrait";
    rev = "v0.6.0";
    hash = "sha256-hxCBomL4Qg9cHLRg9ZiO9k+JVOZXn6f4ikPtK+V9tno=";
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
    libbacktrace
    lz4
    nlohmann_json # alternative JSON parser to rapidjson
    protobuf # substrait requires protobuf
    rapidjson
    re2
    snappy
    thrift
    utf8proc
    zlib
    zstd
  ] ++ lib.optionals enableFlight [
    grpc
    openssl
    protobuf
    sqlite
  ] ++ lib.optionals enableS3 [ aws-sdk-cpp openssl ]
  ++ lib.optionals enableGcs [
    crc32c
    curl
    google-cloud-cpp
    grpc
    nlohmann_json
  ];

  preConfigure = ''
    patchShebangs build-support/
    substituteInPlace "src/arrow/vendored/datetime/tz.cpp" \
      --replace 'discover_tz_dir();' '"${tzdata}/share/zoneinfo";'
  '';

  cmakeFlags = [
    "-DARROW_BUILD_SHARED=${if enableShared then "ON" else "OFF"}"
    "-DARROW_BUILD_STATIC=${if enableShared then "OFF" else "ON"}"
    "-DARROW_BUILD_TESTS=ON"
    "-DARROW_BUILD_INTEGRATION=ON"
    "-DARROW_BUILD_UTILITIES=ON"
    "-DARROW_EXTRA_ERROR_CONTEXT=ON"
    "-DARROW_VERBOSE_THIRDPARTY_BUILD=ON"
    "-DARROW_DEPENDENCY_SOURCE=SYSTEM"
    "-Dxsimd_SOURCE=AUTO"
    "-DARROW_DEPENDENCY_USE_SHARED=${if enableShared then "ON" else "OFF"}"
    "-DARROW_COMPUTE=ON"
    "-DARROW_CSV=ON"
    "-DARROW_DATASET=ON"
    "-DARROW_FILESYSTEM=ON"
    "-DARROW_FLIGHT_SQL=${if enableFlight then "ON" else "OFF"}"
    "-DARROW_HDFS=ON"
    "-DARROW_IPC=ON"
    "-DARROW_JEMALLOC=${if enableJemalloc then "ON" else "OFF"}"
    "-DARROW_JSON=ON"
    "-DARROW_USE_GLOG=ON"
    "-DARROW_WITH_BACKTRACE=ON"
    "-DARROW_WITH_BROTLI=ON"
    "-DARROW_WITH_LZ4=ON"
    "-DARROW_WITH_NLOHMANN_JSON=ON"
    "-DARROW_WITH_SNAPPY=ON"
    "-DARROW_WITH_UTF8PROC=ON"
    "-DARROW_WITH_ZLIB=ON"
    "-DARROW_WITH_ZSTD=ON"
    "-DARROW_MIMALLOC=ON"
    "-DARROW_SUBSTRAIT=ON"
    "-DARROW_FLIGHT=${if enableFlight then "ON" else "OFF"}"
    "-DARROW_FLIGHT_TESTING=${if enableFlight then "ON" else "OFF"}"
    "-DARROW_S3=${if enableS3 then "ON" else "OFF"}"
    "-DARROW_GCS=${if enableGcs then "ON" else "OFF"}"
    # Parquet options:
    "-DARROW_PARQUET=ON"
    "-DPARQUET_BUILD_EXECUTABLES=ON"
    "-DPARQUET_REQUIRE_ENCRYPTION=ON"
  ] ++ lib.optionals (!enableShared) [
    "-DARROW_TEST_LINKAGE=static"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_INSTALL_RPATH=@loader_path/../lib" # needed for tools executables
  ] ++ lib.optionals (!stdenv.isx86_64) [ "-DARROW_USE_SIMD=OFF" ]
  ++ lib.optionals enableS3 [ "-DAWSSDK_CORE_HEADER_FILE=${aws-sdk-cpp}/include/aws/core/Aws.h" ]
  ++ lib.optionals enableGcs [ "-DCMAKE_CXX_STANDARD=${grpc.cxxStandard}" ];

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
    lib.optionalString doInstallCheck "-${lib.concatStringsSep ":" filteredTests}";

  __darwinAllowLocalNetworking = true;

  installCheckInputs = [ perl which sqlite ]
    ++ lib.optionals enableS3 [ minio ]
    ++ lib.optionals enableFlight [ python3 ];

  disabledTests = [
    # requires networking
    "arrow-gcsfs-test"
    "arrow-flight-integration-test"
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    ctest -L unittest --exclude-regex '^(${lib.concatStringsSep "|" disabledTests})$'

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = "https://arrow.apache.org/docs/cpp/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tobim veprbl cpcloud ];
  };
  passthru = {
    inherit enableFlight enableJemalloc enableS3 enableGcs;
  };
}
