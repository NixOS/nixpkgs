{stdenv, fetchurl, perl, perlXMLParser, xkbcomp, gettext, intltool}:

let version = "1.5"; in 

stdenv.mkDerivation {
  name = "xkeyboard-config-${version}";

  src = fetchurl {
    url = "http://xlibs.freedesktop.org/xkbdesc/xkeyboard-config-${version}.tar.bz2";
    sha256 = "1r276ik3x0jg77zza37ggrnp7zbdvmjyrm9mwxxgzh3bmligy5ff";
  };

  buildInputs = [perl perlXMLParser xkbcomp gettext intltool];

  ICONV = "iconv";

  preConfigure = ''
    configureFlags="--with-xkb-base=$out/etc/X11/xkb -with-xkb-rules-symlink=xorg,xfree86"
    sed -e 's@#!\s*/bin/bash@#! /bin/sh@' -i rules/merge.sh
  '';

  postInstall = ''
    cat ${./level3-deadkeys-us-intl} >> $out/etc/X11/xkb/symbols/us
  '';
}
