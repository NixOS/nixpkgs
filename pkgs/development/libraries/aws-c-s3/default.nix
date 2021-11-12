{ lib, stdenv
, fetchFromGitHub
, aws-c-auth
, aws-c-cal
, aws-c-common
, aws-c-compression
, aws-c-http
, aws-c-io
, cmake
, s2n-tls
}:

stdenv.mkDerivation rec {
  pname = "aws-c-s3";
  version = "0.1.27";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-s3";
    rev = "v${version}";
    sha256 = "sha256-GtBUC5cKMN9rd5GQbYoipVvxrUCCNKbb5vhHUGQpeH8=";
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
    s2n-tls
  ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "C99 library implementation for communicating with the S3 service";
    homepage = "https://github.com/awslabs/aws-c-s3";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
