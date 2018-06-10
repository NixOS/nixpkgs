{ stdenv, fetchFromGitHub, pkgconfig, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "pkcs11-helper-${version}";
  version = "1.23";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pkcs11-helper";
    rev = "${name}";
    sha256 = "1m3fp3v6c903cs36bvvg0h65p1sdamsmzy13ww0zyvplcycarz0n";
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
