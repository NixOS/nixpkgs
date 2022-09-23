{ lib, stdenv, fetchFromGitHub, glib, openssl, pkg-config, autoreconfHook, SystemConfiguration }:

stdenv.mkDerivation rec {
  pname = "sofia-sip";
  version = "1.13.9";

  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xF2LFbxGhA/gF7Z2LX3WYq3nXOLi0ARGGR4Dd3PCftk=";
  };

  buildInputs = [ glib openssl ] ++ lib.optional stdenv.isDarwin SystemConfiguration;
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    description = "Open-source SIP User-Agent library, compliant with the IETF RFC3261 specification";
    homepage = "https://github.com/freeswitch/sofia-sip";
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
