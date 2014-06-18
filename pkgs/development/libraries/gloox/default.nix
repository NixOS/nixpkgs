{ stdenv, fetchurl
, zlibSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
, idnSupport ? true, libidn ? null
}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;
assert idnSupport -> libidn != null;

let
  version = "1.0.10";
in
stdenv.mkDerivation rec {
  name = "gloox-${version}";

  src = fetchurl {
    url = "http://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "300e756af97d43f3f70f1e68e4d4c7129d587dface61633f50d2c490876f58a3";
  };

  buildInputs = [ ]
    ++ stdenv.lib.optional zlibSupport zlib
    ++ stdenv.lib.optional sslSupport openssl
    ++ stdenv.lib.optional idnSupport libidn;

  meta = {
    description = "A portable high-level Jabber/XMPP library for C++";
    homepage = "http://camaya.net/gloox";
    license = [ "GPLv3" ];
  };
}
