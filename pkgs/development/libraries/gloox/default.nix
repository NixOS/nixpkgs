{ stdenv, fetchurl
, zlibSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, idnSupport ? true, libidn ? null
}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert idnSupport -> libidn != null;

let
  version = "1.0.13";
in
stdenv.mkDerivation rec {
  name = "gloox-${version}";

  src = fetchurl {
    url = "http://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "12payqyx1ly8nm3qn24bj0kyy9d08sixnjqxw7fn6rbwr7m1x7sd";
  };

  buildInputs = [ ]
    ++ stdenv.lib.optional zlibSupport zlib
    ++ stdenv.lib.optional sslSupport openssl
    ++ stdenv.lib.optional idnSupport libidn;

  meta = {
    description = "A portable high-level Jabber/XMPP library for C++";
    homepage = "http://camaya.net/gloox";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
