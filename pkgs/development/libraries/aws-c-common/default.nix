{ lib, stdenv, fetchFromGitHub, cmake, libexecinfo }:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z02ndb9jjn0p5bcc49pq0d8c0q2pq33dlszw77l76jkhrfx0921";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional stdenv.hostPlatform.isMusl libexecinfo;

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
