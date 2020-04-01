{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "aws-checksums";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "018fnpn0jc686jxp5wf8qxmjphk3z43l8n1mgcgaa9zw94i24jgk";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS:BOOL=ON" ];

  meta = with lib; {
    description = "HW accelerated CRC32c and CRC32";
    homepage = https://github.com/awslabs/aws-checksums;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
