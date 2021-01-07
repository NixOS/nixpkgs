{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.4.63";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "16bc6fn1gq3nqcrzgpi2kjphq7xkkr73aljakrg89ysm6hyzyim9";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin
    "-Wno-nullability-extension -Wno-typedef-redefinition";

  meta = with lib; {
    description = "AWS SDK for C common core";
    homepage = "https://github.com/awslabs/aws-c-common";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
