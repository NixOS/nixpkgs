{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common, aws-checksums }:

stdenv.mkDerivation rec {
  pname = "aws-c-event-stream";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0anjynfghk3inysy21wqvhxha33xsswh3lm8pr7nx7cpj6cmr37m";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common aws-checksums ];

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${aws-c-common}/lib/cmake"
  ];

  meta = with lib; {
    description = "C99 implementation of the vnd.amazon.eventstream content-type";
    homepage = https://github.com/awslabs/aws-c-event-stream;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
