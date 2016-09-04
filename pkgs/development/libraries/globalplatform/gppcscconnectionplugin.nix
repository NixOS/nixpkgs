{ stdenv, fetchurl, pkgconfig, globalplatform, openssl, pcsclite }:

stdenv.mkDerivation rec {
  name = "gppcscconnectionplugin-${version}";
  version  = "1.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/globalplatform/${name}.tar.gz";
    sha256 = "0d3vcrh9z55rbal0dchmj661pqqrav9c400bx1c46grcl1q022ad";
  };

  buildInputs = [ pkgconfig globalplatform openssl pcsclite ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/p/globalplatform/wiki/Home/;
    description = "GlobalPlatform pcsc connection plugin";
    license = [ licenses.lgpl3 licenses.gpl3 ];
    platforms = platforms.all;
  };
}
