{ stdenv, fetchFromGitHub, pkgconfig, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "pkcs11-helper-${version}";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    rev = "${name}";
    sha256 = "1m7vd3f9dphcwnwz4vn2gh7byxzjfc836z0lg440yrilww20yhpy";
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
