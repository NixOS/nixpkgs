{ stdenv, fetchurl
, zlibSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, idnSupport ? true, libidn ? null
}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert idnSupport -> libidn != null;

let
  version = "1.0.12";
in
stdenv.mkDerivation rec {
  name = "gloox-${version}";

  src = fetchurl {
    url = "http://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "1aa3pkg8yz6glg2273yl7310nkx1q31wkwbmmxwk3059k0p5l4k7";
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
