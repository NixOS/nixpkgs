{ stdenv, fetchurl, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "wolfssl-${version}";
  version = "3.7.0";

  src = fetchurl {
    url    = "https://github.com/wolfSSL/wolfssl/archive/v${version}.tar.gz";
    sha256 = "1r1awivral4xjjvnna9lrfz2rh84rcbp04834rymbsz0kbyykgb6";
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
