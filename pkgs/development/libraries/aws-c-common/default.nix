{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z76gxmkd1d2f077fn3s129qs68883lprr7sghh2hbsq4nfbwxrx";
  };

  nativeBuildInputs = [ cmake ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [
    "-Wno-nullability-extension"
    "-Wno-typedef-redefinition"
  ];

  meta = with lib; {
    description = "AWS SDK for C common core";
    homepage = https://github.com/awslabs/aws-c-common;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
