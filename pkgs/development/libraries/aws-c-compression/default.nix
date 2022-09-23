{ lib, stdenv
, fetchFromGitHub
, aws-c-common
, cmake
}:

stdenv.mkDerivation rec {
  pname = "aws-c-compression";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-compression";
    rev = "v${version}";
    sha256 = "sha256-VWQsPEanti6EyAfDbdUfFwe3sh/AhElytTQn2ZpLVgg=";
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

  meta = with lib; {
    description = "C99 implementation of huffman encoding/decoding";
    homepage = "https://github.com/awslabs/aws-c-compression";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
