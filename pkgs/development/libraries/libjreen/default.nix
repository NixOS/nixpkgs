{ lib, stdenv, fetchurl, cmake, qt4, pkg-config, gsasl }:

stdenv.mkDerivation rec {
  pname = "libjreen";
  version = "1.2.0";

  src = fetchurl {
    url = "https://qutim.org/dwnl/73/${pname}-${version}.tar.bz2";
    sha256 = "14nwwk40xx8w6x7yaysgcr0lgzhs7l064f7ikp32s5y9a8mmp582";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ qt4 gsasl ];

  meta = {
    description = "C++ Jabber library using Qt framework";
    homepage = "https://qutim.org/jreen/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
