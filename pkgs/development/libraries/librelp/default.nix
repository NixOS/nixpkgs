{ stdenv, fetchFromGitHub
, autoreconfHook
, gnutls
, openssl
, pkgconfig
, zlib
}:

stdenv.mkDerivation rec {
  pname = "librelp";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "librelp";
    rev = "v${version}";
    sha256 = "132i1b1m7c7hkbxsnpa7n07cbghxjxmcbb8zhgwziaxg4nzxsa6l";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ gnutls zlib openssl ];

  meta = with stdenv.lib; {
    description = "A reliable logging library";
    homepage = "https://www.librelp.com/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
