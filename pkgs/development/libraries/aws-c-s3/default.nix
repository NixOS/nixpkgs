{ lib, stdenv
, fetchFromGitHub
, aws-c-auth
, aws-c-cal
, aws-c-common
, aws-c-compression
, aws-c-http
, aws-c-io
, aws-checksums
, cmake
, nix
, s2n-tls
}:

stdenv.mkDerivation rec {
  pname = "aws-c-s3";
<<<<<<< HEAD
  version = "0.3.13";
=======
  version = "0.2.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-s3";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-SXMDyzQ8hjPx9q9GhE11lYjj3IZY35mvUWELlYQmgGU=";
=======
    sha256 = "sha256-kwYzsKdEy+e0GxqYcakcdwoaC2LLPZe8E7bZNrmqok0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-auth
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-http
    aws-c-io
    aws-checksums
    s2n-tls
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "C99 library implementation for communicating with the S3 service";
    homepage = "https://github.com/awslabs/aws-c-s3";
    license = licenses.asl20;
    maintainers = with maintainers; [ r-burns ];
    mainProgram = "s3";
    platforms = platforms.unix;
  };
}
