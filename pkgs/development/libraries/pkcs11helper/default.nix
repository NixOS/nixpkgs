{ lib, stdenv, fetchFromGitHub, pkg-config, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "pkcs11-helper";
  version = "1.27";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    rev = "${pname}-${version}";
    sha256 = "1idrqip59bqzcgddpnk2inin5n5yn4y0dmcyaggfpdishraiqgd5";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/OpenSC/pkcs11-helper";
    license = with licenses; [ bsd3 gpl2 ];
    description = "Library that simplifies the interaction with PKCS#11 providers";
    platforms = platforms.unix;
  };
}
