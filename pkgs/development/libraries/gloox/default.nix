{ stdenv, fetchurl
, zlibSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, idnSupport ? true, libidn ? null
}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert idnSupport -> libidn != null;

let
  version = "1.0.14";
in
stdenv.mkDerivation rec {
  name = "gloox-${version}";

  src = fetchurl {
    url = "http://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "0h9r4382qv0vqc91x1qz1nivxw1r2l874s1kl0bskzm9dyk742sj";
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
    platforms = with stdenv.lib.platforms; unix;
  };
}
