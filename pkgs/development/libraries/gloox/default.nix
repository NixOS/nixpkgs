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
  version = "1.0.24";
in
stdenv.mkDerivation {
  pname = "gloox";
  inherit version;

  src = fetchurl {
    url = "https://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "1jgrd07qr9jvbb5hcmhrqz4w4lvwc51m30jls1fgxf1f5az6455f";
  };

  buildInputs = [ ]
    ++ optional zlibSupport zlib
    ++ optional sslSupport openssl
    ++ optional idnSupport libidn;

  meta = {
    description = "A portable high-level Jabber/XMPP library for C++";
    homepage = "http://camaya.net/gloox";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
