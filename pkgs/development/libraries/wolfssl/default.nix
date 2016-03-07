{ stdenv, fetchFromGitHub, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "wolfssl-${version}";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "v${version}";
    sha256 = "0vc2120a9gfxg3rv018ch1g84ia2cpplcqbpy8v6vpfb79rn1nf5";
  };

  nativeBuildInputs = [ autoconf automake libtool ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "A small, fast, portable implementation of TLS/SSL for embedded devices";
    homepage    = "https://www.wolfssl.com/";
    platforms   = platforms.all;
    maintainers = with maintainers; [ mcmtroffaes ];
  };
}
