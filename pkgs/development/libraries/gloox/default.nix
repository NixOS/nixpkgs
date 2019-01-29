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
  version = "1.0.22";
in
stdenv.mkDerivation rec {
  name = "gloox-${version}";

  src = fetchurl {
    url = "https://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "0r69gq8if9yy1amjzl7qrq9lzhhna7qgz905ln4wvkwchha1ppja";
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
