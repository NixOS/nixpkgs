{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a7hi4crnc3j1j39qcnd44zqdfwzw1xghcf80marx5vdf1qdzy6p";
  };

  nativeBuildInputs = [ cmake ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin
    "-Wno-nullability-extension -Wno-typedef-redefinition";

  meta = with lib; {
    description = "AWS SDK for C common core";
    homepage = https://github.com/awslabs/aws-c-common;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
