{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.4.12";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "086jffbsch3qbnq3dkqd8mmhbjxyg8rrz4m94s6wiqv9yc2xb2qq";
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
