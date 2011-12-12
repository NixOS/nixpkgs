{ stdenv, fetchurl, perl, perlXMLParser, xkbcomp, gettext, intltool  }:

stdenv.mkDerivation rec {
  name = "xkeyboard-config-2.1";

  src = fetchurl {
    url = "mirror://xorg/individual/data/xkeyboard-config/${name}.tar.bz2";
    sha256 = "0x9hkb4iqz64gcabzkdcfy4p78sdhnpjwh54g8wx5bdgy9087vpr";
  };

  buildInputs = [ gettext ];

  buildNativeInputs = [ perl perlXMLParser intltool xkbcomp ];

  patches = [ ./eo.patch ];

  preConfigure = ''
    configureFlags="--with-xkb-base=$out/etc/X11/xkb -with-xkb-rules-symlink=xorg,xfree86"
    sed -e 's@#!\s*/bin/bash@#! /bin/sh@' -i rules/merge.sh
  '';

  postInstall = ''
    cat ${./level3-deadkeys-us-intl} >> $out/etc/X11/xkb/symbols/us
  '';
}
