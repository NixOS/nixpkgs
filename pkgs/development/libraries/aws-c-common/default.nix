{ lib, stdenv, fetchFromGitHub, cmake, libexecinfo }:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "04wrmrw83vypqzsq88b2q8kp5sfbv0qsci3bcxw0c2mfxqk8358n";
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
