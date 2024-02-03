{ lib, stdenv, fetchFromGitHub, autoreconfHook, openssl, curl }:

stdenv.mkDerivation rec {
  pname = "libksi";
  version = "3.21.3075";

  src = fetchFromGitHub {
    owner = "Guardtime";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JEdjy91+8xJPNzjkumadT05SxcvtM551+SjLN1SQcAU=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl curl ];

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-cafile=/etc/ssl/certs/ca-certificates.crt"
  ];

  meta = with lib; {
    homepage = "https://github.com/GuardTime/libksi";
    description = "Keyless Signature Infrastructure API library";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
