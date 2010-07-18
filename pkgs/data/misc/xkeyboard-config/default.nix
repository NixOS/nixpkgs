{stdenv, fetchurl, perl, perlXMLParser, xkbcomp, gettext, intltool}:

stdenv.mkDerivation rec {
  name = "xkeyboard-config-1.9";

  src = fetchurl {
    url = "mirror://xorg/individual/data/xkeyboard-config/${name}.tar.bz2";
    sha256 = "0df2iad598pxw3fzkx10f7irqah0fgawx262d07s04x0whn9ql9b";
  };

  buildInputs = [perl perlXMLParser xkbcomp gettext intltool];

  patches = [ ./eo.patch ];

  preConfigure = ''
    configureFlags="--with-xkb-base=$out/etc/X11/xkb -with-xkb-rules-symlink=xorg,xfree86"
    sed -e 's@#!\s*/bin/bash@#! /bin/sh@' -i rules/merge.sh
  '';

  postInstall = ''
    cat ${./level3-deadkeys-us-intl} >> $out/etc/X11/xkb/symbols/us
  '';
}
