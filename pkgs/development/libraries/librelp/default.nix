{ lib, stdenv, fetchFromGitHub
, autoreconfHook
, gnutls
, openssl
, pkg-config
, zlib
}:

stdenv.mkDerivation rec {
  pname = "librelp";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "librelp";
    rev = "v${version}";
    sha256 = "sha256-aJLsUtik5aXfsdi+8QoDgbi4VUZ8gV3YPA6kIY6wzs4=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ gnutls zlib openssl ];

  meta = with lib; {
    description = "A reliable logging library";
    homepage = "https://www.librelp.com/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
