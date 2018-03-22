{ stdenv, fetchFromGitHub, pkgconfig, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "pkcs11-helper-${version}";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    rev = "${name}";
    sha256 = "01v3zv6sr5phqhr2f21fl2rmcnmkp9518dkq82g1v2y9ysjksg7q";
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
