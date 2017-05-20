{ stdenv, fetchurl
, zlibSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, idnSupport ? true, libidn ? null
}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert idnSupport -> libidn != null;

with stdenv.lib;

let
  version = "1.0.20";
in
stdenv.mkDerivation rec {
  name = "gloox-${version}";

  src = fetchurl {
    url = "http://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "1a6yhs42wcdm8az3983m3lx4d9296bw0amz5v3b4012g1xn0hhq2";
  };

  buildInputs = [ ]
    ++ optional zlibSupport zlib
    ++ optional sslSupport openssl
    ++ optional idnSupport libidn;

  meta = {
    description = "A portable high-level Jabber/XMPP library for C++";
    homepage = http://camaya.net/gloox;
    license = licenses.gpl3;
    maintainers = with maintainers; [ fuuzetsu ];
    platforms = platforms.unix;
  };
}
