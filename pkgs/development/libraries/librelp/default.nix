{ stdenv, fetchFromGitHub
, autoreconfHook
, gnutls
, openssl
, pkgconfig
, zlib
}:

stdenv.mkDerivation rec {
  pname = "librelp";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "librelp";
    rev = "v${version}";
    sha256 = "1il8dany6y981ficrwnxjlc13v5lj6gqia5678p5pj6bcbq7l7lb";
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
