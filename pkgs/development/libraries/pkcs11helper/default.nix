{ lib, stdenv, fetchFromGitHub, pkg-config, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "pkcs11-helper";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    rev = "${pname}-${version}";
    hash = "sha256-FP3y/YHsPPqey4QfxIiC4QjruuK1K2Bg+2QL2gXDT+k=";
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
