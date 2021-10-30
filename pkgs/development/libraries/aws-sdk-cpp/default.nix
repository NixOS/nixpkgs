{ lib, stdenv, fetchFromGitHub, cmake, curl, openssl, s2n-tls, zlib
, aws-crt-cpp
, aws-c-cal, aws-c-common, aws-c-event-stream, aws-c-io, aws-checksums
, CoreAudio, AudioToolbox
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
  version = "1.9.121";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-sdk-cpp";
    rev = version;
    sha256 = "sha256-VQpWauk0tdJ1QU0HmtdTwQdKbiAuTTXXsUo2cqpqmdU=";
  };

  postPatch = ''
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
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
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

  # aws-cpp-sdk-core-tests/aws/auth/AWSCredentialsProviderTest.cpp
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
  ];

  # Builds in 2+h with 2 cores, and ~10m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "A C++ interface for Amazon Web Services";
    homepage = "https://github.com/awslabs/aws-sdk-cpp";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eelco orivej ];
  };
}
