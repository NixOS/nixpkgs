{ stdenv, fetchurl
, zlibSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, idnSupport ? true, libidn ? null
}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert idnSupport -> libidn != null;

let
  version = "1.0.11";
in
stdenv.mkDerivation rec {
  name = "gloox-${version}";

  src = fetchurl {
    url = "http://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "1hrkvn4ddzmydvpr541l6pi8nr0k6xi9g7yxdp84ns7v463kjrq9";
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
