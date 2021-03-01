{ lib, stdenv, fetchFromGitHub, glib, openssl, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "sofia-sip";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = pname;
    rev = "v${version}";
    sha256 = "01xj30hhm1ji76igkqkn63rw42vvzq3azkr9qz6fy83iwqaybgyn";
  };

  buildInputs = [ glib openssl ];
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    description = "Open-source SIP User-Agent library, compliant with the IETF RFC3261 specification";
    homepage = "https://github.com/freeswitch/sofia-sip";
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
