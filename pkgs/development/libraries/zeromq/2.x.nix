{stdenv, fetchurl, libuuid}:

stdenv.mkDerivation rec {
  name = "zeromq-2.2.0";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "0ds6c244wik1lyfrfr2f4sha30fly4xybr02r9r4z156kvmlm423";
  };

  buildInputs = [ libuuid ];

  meta = {
    branch = "2";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
    platforms = stdenv.lib.platforms.unix;
  };
}
