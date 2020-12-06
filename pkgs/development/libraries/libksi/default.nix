{ stdenv, fetchFromGitHub, autoreconfHook, openssl, curl }:

stdenv.mkDerivation rec {
  pname = "libksi";
  version = "3.20.3025";

  src = fetchFromGitHub {
    owner = "Guardtime";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cagysr8j92r6g7f0mwrlkpn9xz9ncz2v3jymh47j3ljxmfbagpz";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl curl ];

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-cafile=/etc/ssl/certs/ca-certificates.crt"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/GuardTime/libksi";
    description = "Keyless Signature Infrastructure API library";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
