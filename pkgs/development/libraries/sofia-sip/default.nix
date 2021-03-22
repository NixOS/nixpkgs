{ lib, stdenv, fetchFromGitHub, glib, openssl, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "sofia-sip";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qMgZpLo/BHGJbJ0DDN8COHAhU3ujWgVK9oZOnnMwKas=";
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
