{ lib, stdenv, fetchFromGitHub, cmake, curl, openssl, zlib
, aws-c-common, aws-c-event-stream, aws-checksums
, CoreAudio, AudioToolbox
, # Allow building a limited set of APIs, e.g. ["s3" "ec2"].
  apis ? ["*"]
, # Whether to enable AWS' custom memory management.
  customMemoryManagement ? true
}:

stdenv.mkDerivation rec {
  name = "aws-sdk-cpp-${version}";
  version = "1.7.90";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-sdk-cpp";
    rev = version;
    sha256 = "0zpqi612qmm0n53crxiisv0vdif43ymg13kafy6vv43j2wmh66ga";
  };

  # FIXME: might be nice to put different APIs in different outputs
  # (e.g. libaws-cpp-sdk-s3.so in output "s3").
  outputs = [ "out" "dev" ];
  separateDebugInfo = stdenv.isLinux;

  nativeBuildInputs = [ cmake curl ];

  buildInputs = [
    curl openssl zlib
    aws-c-common aws-c-event-stream aws-checksums
  ] ++ lib.optionals (stdenv.isDarwin &&
                        ((builtins.elem "text-to-speech" apis) ||
                         (builtins.elem "*" apis)))
         [ CoreAudio AudioToolbox ];

  cmakeFlags = [
    "-DBUILD_DEPS=OFF"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
  ] ++ lib.optional (!customMemoryManagement) "-DCUSTOM_MEMORY_MANAGEMENT=0"
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "-DENABLE_TESTING=OFF"
    ++ lib.optional (apis != ["*"])
      "-DBUILD_ONLY=${lib.concatStringsSep ";" apis}";

  preConfigure =
    ''
      rm aws-cpp-sdk-core-tests/aws/auth/AWSCredentialsProviderTest.cpp
    '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A C++ interface for Amazon Web Services";
    homepage = https://github.com/awslabs/aws-sdk-cpp;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eelco orivej ];
  };
}
