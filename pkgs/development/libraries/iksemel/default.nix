{ stdenv, autoreconfHook, libtool, pkgconfig, gnutls, fetchFromGitHub, texinfo }:

stdenv.mkDerivation rec {
  pname = "iksemel";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "timothytylee";
    repo = "iksemel-1.4";
    rev = "v${version}";
    sha256 = "1xv302p344hnpxqcgs3z6wwxhrik39ckgfw5cjyrw0dkf316z9yh";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook libtool texinfo ];
  buildInputs = [ gnutls ];

  meta = with stdenv.lib; {
    description = "XML parser for jabber";

    homepage = https://github.com/timothytylee/iksemel-1.4;
    license = licenses.gpl2;
    maintainers = with maintainers; [ disassembler ];
    platforms = platforms.linux;
  };
}
