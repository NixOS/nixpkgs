{ lib, stdenv
, fetchFromGitHub
, aws-c-cal
, aws-c-common
, aws-c-compression
, aws-c-io
, cmake
, s2n-tls
}:

stdenv.mkDerivation rec {
  pname = "aws-c-http";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-http";
    rev = "v${version}";
    sha256 = "sha256-JqFvKoWW/2UV0jcR50QlD+LEPwQ4qwPoaPpioAuwf90=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-io
    s2n-tls
  ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "C99 implementation of the HTTP/1.1 and HTTP/2 specifications";
    homepage = "https://github.com/awslabs/aws-c-http";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
