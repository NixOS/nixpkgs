{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, curl
, openssl
, s2n-tls
, zlib
, aws-crt-cpp
, aws-c-cal
, aws-c-common
, aws-c-event-stream
, aws-c-io
, aws-checksums
, CoreAudio
, AudioToolbox
, # Allow building a limited set of APIs, e.g. ["s3" "ec2"].
  apis ? ["*"]
, # Whether to enable AWS' custom memory management.
  customMemoryManagement ? true
}:

let
  host_os = if stdenv.hostPlatform.isDarwin then "APPLE"
       else if stdenv.hostPlatform.isAndroid then "ANDROID"
       else if stdenv.hostPlatform.isWindows then "WINDOWS"
       else if stdenv.hostPlatform.isLinux then "LINUX"
       else throw "Unknown host OS";
in

stdenv.mkDerivation rec {
  pname = "aws-sdk-cpp";
  version = if stdenv.system == "i686-linux" then "1.9.150"
    else "1.9.238";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sdk-cpp";
    rev = version;
    sha256 = if version == "1.9.150" then "fgLdXWQKHaCwulrw9KV3vpQ71DjnQAL4heIRW7Rk7UY="
      else "sha256-pEmsTfZXsvJMV79dGkjDNbUVajwyoYgzE5DCsC53pGY=";
  };

  postPatch = ''
    # Missing includes for GCC11
    sed '5i#include <thread>' -i \
      aws-cpp-sdk-cloudfront-integration-tests/CloudfrontOperationTest.cpp \
      aws-cpp-sdk-cognitoidentity-integration-tests/IdentityPoolOperationTest.cpp \
      aws-cpp-sdk-dynamodb-integration-tests/TableOperationTest.cpp \
      aws-cpp-sdk-elasticfilesystem-integration-tests/ElasticFileSystemTest.cpp \
      aws-cpp-sdk-lambda-integration-tests/FunctionTest.cpp \
      aws-cpp-sdk-mediastore-data-integration-tests/MediaStoreDataTest.cpp \
      aws-cpp-sdk-queues/source/sqs/SQSQueue.cpp \
      aws-cpp-sdk-redshift-integration-tests/RedshiftClientTest.cpp \
      aws-cpp-sdk-s3-crt-integration-tests/BucketAndObjectOperationTest.cpp \
      aws-cpp-sdk-s3-integration-tests/BucketAndObjectOperationTest.cpp \
      aws-cpp-sdk-s3control-integration-tests/S3ControlTest.cpp \
      aws-cpp-sdk-sqs-integration-tests/QueueOperationTest.cpp \
      aws-cpp-sdk-transfer-tests/TransferTests.cpp
    # Flaky on Hydra
    rm aws-cpp-sdk-core-tests/aws/auth/AWSCredentialsProviderTest.cpp
    # Includes aws-c-auth private headers, so only works with submodule build
    rm aws-cpp-sdk-core-tests/aws/auth/AWSAuthSignerTest.cpp
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    # TestRandomURLMultiThreaded fails
    rm aws-cpp-sdk-core-tests/http/HttpClientTest.cpp
  '';

  # FIXME: might be nice to put different APIs in different outputs
  # (e.g. libaws-cpp-sdk-s3.so in output "s3").
  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake curl ];

  buildInputs = [
    curl openssl zlib
  ] ++ lib.optionals (stdenv.isDarwin &&
                        ((builtins.elem "text-to-speech" apis) ||
                         (builtins.elem "*" apis)))
         [ CoreAudio AudioToolbox ];

  # propagation is needed for Security.framework to be available when linking
  propagatedBuildInputs = [ aws-crt-cpp ];

  cmakeFlags = [
    "-DBUILD_DEPS=OFF"
  ] ++ lib.optional (!customMemoryManagement) "-DCUSTOM_MEMORY_MANAGEMENT=0"
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-DENABLE_TESTING=OFF"
    "-DCURL_HAS_H2=1"
    "-DCURL_HAS_TLS_PROXY=1"
    "-DTARGET_ARCH=${host_os}"
  ] ++ lib.optional (apis != ["*"])
    "-DBUILD_ONLY=${lib.concatStringsSep ";" apis}";

  # fix build with gcc9, can be removed after bumping to current version
  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  # aws-cpp-sdk-core-tests/aws/client/AWSClientTest.cpp
  # seem to have a datarace
  enableParallelChecking = false;

  postFixupHooks = [
    # This bodge is necessary so that the file that the generated -config.cmake file
    # points to an existing directory.
    "mkdir -p $out/include"
  ];

  __darwinAllowLocalNetworking = true;

  patches = [
    ./cmake-dirs.patch
  ]
    ++ lib.optional (lib.versionOlder version "1.9.163")
      (fetchpatch {
        url = "https://github.com/aws/aws-sdk-cpp/commit/b102aaf5693c4165c84b616ab9ffb9edfb705239.diff";
        sha256 = "sha256-38QBo3MEFpyHPb8jZEURRPkoeu4DqWhVeErJayiHKF0=";
      });

  # Builds in 2+h with 2 cores, and ~10m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "A C++ interface for Amazon Web Services";
    homepage = "https://github.com/aws/aws-sdk-cpp";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eelco orivej ];
  };
}
