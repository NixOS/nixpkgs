{ lib, stdenv, fetchurl, pkg-config, globalplatform, openssl_1_0_2, pcsclite }:

stdenv.mkDerivation rec {
  pname = "gppcscconnectionplugin";
  version  = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/globalplatform/${pname}-${version}.tar.gz";
    sha256 = "0d3vcrh9z55rbal0dchmj661pqqrav9c400bx1c46grcl1q022ad";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ globalplatform openssl_1_0_2 pcsclite ];

  meta = with lib; {
    homepage = "https://sourceforge.net/p/globalplatform/wiki/Home/";
    description = "GlobalPlatform pcsc connection plugin";
    license = [ licenses.lgpl3 licenses.gpl3 ];
    platforms = platforms.all;
  };
}
