{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common }:

stdenv.mkDerivation rec {
  pname = "aws-checksums";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pSUSJTbwKYF2GsJG8DhLxxsv1ssp+/1c2gMY4dXbdFQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "HW accelerated CRC32c and CRC32";
    homepage = "https://github.com/awslabs/aws-checksums";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
