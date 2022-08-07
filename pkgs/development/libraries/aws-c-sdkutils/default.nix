{ lib, stdenv
, fetchFromGitHub
, aws-c-common
, cmake
}:

stdenv.mkDerivation rec {
  pname = "aws-c-sdkutils";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-sdkutils";
    rev = "v${version}";
    sha256 = "sha256-G+ykP39EmI8BCeulTsZ/OSFKRzXVbEK0+mtJ3tugl5M=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-common
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  doCheck = true;

  meta = with lib; {
    description = "AWS SDK utility library";
    homepage = "https://github.com/awslabs/aws-c-sdkutils";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
