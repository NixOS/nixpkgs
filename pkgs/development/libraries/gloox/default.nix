{ lib, stdenv, fetchurl
, zlibSupport ? true, zlib
, sslSupport ? true, openssl
, idnSupport ? true, libidn
}:


stdenv.mkDerivation rec{
  pname = "gloox";
  version = "1.0.24";

  src = fetchurl {
    url = "https://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "1jgrd07qr9jvbb5hcmhrqz4w4lvwc51m30jls1fgxf1f5az6455f";
  };

  buildInputs = [ ]
    ++ lib.optional zlibSupport zlib
    ++ lib.optional sslSupport openssl
    ++ lib.optional idnSupport libidn;

  meta = with lib; {
    description = "A portable high-level Jabber/XMPP library for C++";
    homepage = "http://camaya.net/gloox";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
