{ stdenv, fetchFromGitHub, autoreconfHook, openssl, curl }:

stdenv.mkDerivation rec {
  name = "libksi-2015-07-03";

  src = fetchFromGitHub {
    owner = "Guardtime";
    repo = "libksi";
    rev = "b82dd65bd693722db92397cbe0920170e0d2ae1c";
    sha256 = "1sqd31l55kx6knl0sg26ail1k5rgmamq8760p6aj7bpb4jwb8r1n";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl curl ];

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-cafile=/etc/ssl/certs/ca-certificates.crt"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/GuardTime/libksi;
    description = "Keyless Signature Infrastructure API library";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
