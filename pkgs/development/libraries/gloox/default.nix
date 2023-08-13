{ lib, stdenv, fetchurl
, zlibSupport ? true, zlib
, sslSupport ? true, openssl
, idnSupport ? true, libidn
}:


stdenv.mkDerivation rec{
  pname = "gloox";
  version = "1.0.27";

  src = fetchurl {
    url = "https://camaya.net/download/gloox-${version}.tar.bz2";
    sha256 = "sha256-C4tzcUObxY2eUThLYWyWSxi3tBuHrxt4VRBDgO2ob/s=";
  };

  # needed since gcc12
  postPatch = ''
    sed '1i#include <ctime>' -i \
      src/tests/{tag/tag_perf.cpp,zlib/zlib_perf.cpp} \
      src/examples/*.cpp
  '';

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
