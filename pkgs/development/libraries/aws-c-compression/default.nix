{ lib, stdenv
, fetchFromGitHub
, aws-c-common
, cmake
}:

stdenv.mkDerivation rec {
  pname = "aws-c-compression";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-compression";
    rev = "v${version}";
    sha256 = "0fs3zhhzxsb9nfcjpvfbcq79hal7si2ia1c09scab9a8m264f4vd";
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
