{ lib, stdenv, fetchFromGitHub, pkg-config, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "pkcs11-helper";
  version = "1.28";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    rev = "${pname}-${version}";
    sha256 = "sha256-gy04f62TX42mW4hKD/jTZXTpz9v6gQXNrY/pv8Ie4p0=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/OpenSC/pkcs11-helper";
    license = with licenses; [ bsd3 gpl2Only ];
    description = "Library that simplifies the interaction with PKCS#11 providers";
    platforms = platforms.unix;
  };
}
