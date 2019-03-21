{ stdenv, fetchFromGitHub, pkgconfig, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "pkcs11-helper-${version}";
  version = "1.25.1";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    rev = "${name}";
    sha256 = "1nvj6kdbps860kw64m2rz3v2slyn7jkagfdmskrl6966n99iy2ns";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/OpenSC/pkcs11-helper;
    license = with licenses; [ bsd3 gpl2 ];
    description = "Library that simplifies the interaction with PKCS#11 providers";
    platforms = platforms.unix;
  };
}
