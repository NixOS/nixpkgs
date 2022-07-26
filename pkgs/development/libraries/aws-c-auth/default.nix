{ lib, stdenv
, fetchFromGitHub
, aws-c-cal
, aws-c-common
, aws-c-compression
, aws-c-http
, aws-c-io
, aws-c-sdkutils
, cmake
, s2n-tls
}:

stdenv.mkDerivation rec {
  pname = "aws-c-auth";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-auth";
    rev = "v${version}";
    sha256 = "sha256-f1STZdxj8cdK60dCgl2Xfsqaa/x3Z1xEjH3p4GUwGUg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-http
    aws-c-io
    s2n-tls
  ];

  propagatedBuildInputs = [
    aws-c-sdkutils
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "C99 library implementation of AWS client-side authentication";
    homepage = "https://github.com/awslabs/aws-c-auth";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
