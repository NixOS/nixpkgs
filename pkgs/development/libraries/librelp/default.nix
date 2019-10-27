{ stdenv, fetchFromGitHub
, autoreconfHook
, gnutls
, openssl
, pkgconfig
, zlib
}:

stdenv.mkDerivation rec {
  pname = "librelp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "librelp";
    rev = "v${version}";
    sha256 = "1q0k8zm7p6wpkri419kkpz734lp1hnxfqx1aa3xys4pj7zgx9jck";
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
