{ lib, stdenv, fetchFromGitHub, cmake, curl, openssl, s2n, zlib
, aws-c-cal, aws-c-common, aws-c-event-stream, aws-c-io, aws-checksums
, CoreAudio, AudioToolbox
, # Allow building a limited set of APIs, e.g. ["s3" "ec2"].
  apis ? ["*"]
, # Whether to enable AWS' custom memory management.
  customMemoryManagement ? true
}:

stdenv.mkDerivation rec {
  pname = "aws-sdk-cpp";
  version = "1.8.113";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-sdk-cpp";
    rev = version;
    sha256 = "0y784cjrxgrin3ck5f2lk0riyy9kv928kcb9y0gzka65imgma48c";
  };

  # FIXME: might be nice to put different APIs in different outputs
  # (e.g. libaws-cpp-sdk-s3.so in output "s3").
  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake curl ];

  buildInputs = [
    curl openssl s2n zlib
    aws-c-cal aws-c-common aws-c-event-stream aws-c-io aws-checksums
  ] ++ lib.optionals (stdenv.isDarwin &&
                        ((builtins.elem "text-to-speech" apis) ||
                         (builtins.elem "*" apis)))
         [ CoreAudio AudioToolbox ];

  cmakeFlags = [
    "-DBUILD_DEPS=OFF"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
  ] ++ lib.optional (!customMemoryManagement) "-DCUSTOM_MEMORY_MANAGEMENT=0"
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-DENABLE_TESTING=OFF"
    "-DCURL_HAS_H2=0"
  ] ++ lib.optional (apis != ["*"])
    "-DBUILD_ONLY=${lib.concatStringsSep ";" apis}";

  # fix build with gcc9, can be removed after bumping to current version
  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  preConfigure =
    ''
      rm aws-cpp-sdk-core-tests/aws/auth/AWSCredentialsProviderTest.cpp
    '';

  postFixupHooks = [
    # This bodge is necessary so that the file that the generated -config.cmake file
    # points to an existing directory.
    ''mkdir -p $out/include''
  ];

  __darwinAllowLocalNetworking = true;

  patches = [
    ./cmake-dirs.patch
  ];

  meta = with lib; {
    description = "A C++ interface for Amazon Web Services";
    homepage = "https://github.com/awslabs/aws-sdk-cpp";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ eelco orivej ];
  };
}
