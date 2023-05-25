{ lib
, stdenv
, fetchFromGitHub
, cmake
, curl
, openssl
, zlib
, aws-crt-cpp
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
  version = "1.11.37";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sdk-cpp";
    rev = version;
    sha256 = "sha256-C1PdLNagoIMk9/AAV2Pp7kWcspasJtN9Tx679FnEprc=";
  };

  patches = [
    ./cmake-dirs.patch
  ];

  postPatch = ''
    # Avoid blanket -Werror to evade build failures on less
    # tested compilers.
    substituteInPlace cmake/compiler_settings.cmake \
      --replace '"-Werror"' ' '

    # Flaky on Hydra
    rm tests/aws-cpp-sdk-core-tests/aws/auth/AWSCredentialsProviderTest.cpp
    # Includes aws-c-auth private headers, so only works with submodule build
    rm tests/aws-cpp-sdk-core-tests/aws/auth/AWSAuthSignerTest.cpp
    # TestRandomURLMultiThreaded fails
    rm tests/aws-cpp-sdk-core-tests/http/HttpClientTest.cpp
  '' + lib.optionalString stdenv.isi686 ''
    # EPSILON is exceeded
    rm tests/aws-cpp-sdk-core-tests/aws/client/AdaptiveRetryStrategyTest.cpp
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
  # Ensure the linker is using atomic when compiling for RISC-V, otherwise fails
  LDFLAGS = lib.optionalString stdenv.hostPlatform.isRiscV "-latomic";

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

  env.NIX_CFLAGS_COMPILE = toString [
    # openssl 3 generates several deprecation warnings
    "-Wno-error=deprecated-declarations"
  ];

  # aws-cpp-sdk-core-tests/aws/client/AWSClientTest.cpp
  # seem to have a datarace
  enableParallelChecking = false;

  postFixupHooks = [
    # This bodge is necessary so that the file that the generated -config.cmake file
    # points to an existing directory.
    "mkdir -p $out/include"
  ];

  __darwinAllowLocalNetworking = true;

  # Builds in 2+h with 2 cores, and ~10m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "A C++ interface for Amazon Web Services";
    homepage = "https://github.com/aws/aws-sdk-cpp";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eelco orivej ];
    # building ec2 runs out of memory: cc1plus: out of memory allocating 33554372 bytes after a total of 74424320 bytes
    broken = stdenv.buildPlatform.is32bit && ((builtins.elem "ec2" apis) || (builtins.elem "*" apis));
  };
}
