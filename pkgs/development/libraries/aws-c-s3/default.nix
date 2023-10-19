{ lib
, stdenv
, aws-c-auth
, aws-c-cal
, aws-c-common
, aws-c-compression
, aws-c-http
, aws-c-io
, aws-checksums
, cmake
, fetchFromGitHub
, nix
, s2n-tls
}:

stdenv.mkDerivation rec {
  pname = "aws-c-s3";
  version = "0.3.18";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-s3";
    rev = "refs/tags/v${version}";
    hash = "sha256-jJSQ8q/oPul3cQxqM/4BV7Xa+rLDdqvO8Ke32kXdAtQ=";
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
    changelog = "https://github.com/awslabs/aws-c-s3/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ r-burns ];
    mainProgram = "s3";
    platforms = platforms.unix;
  };
}
