{ stdenv, fetchFromGitHub, pkgconfig, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "pkcs11-helper";
  version = "1.26";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    rev = "${pname}-${version}";
    sha256 = "15n3vy1v5gian0gh5y7vq5a6n3fngfwb41sbvrlwbjw0yh23sb1b";
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
