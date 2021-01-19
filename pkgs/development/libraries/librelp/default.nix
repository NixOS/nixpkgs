{ stdenv, fetchFromGitHub
, autoreconfHook
, gnutls
, openssl
, pkg-config
, zlib
}:

stdenv.mkDerivation rec {
  pname = "librelp";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "librelp";
    rev = "v${version}";
    sha256 = "0miqjck9zh1hgsx1v395n0d4f1a1p5a8khybv2nsfjq04g9359c9";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ gnutls zlib openssl ];

  meta = with stdenv.lib; {
    description = "A reliable logging library";
    homepage = "https://www.librelp.com/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
