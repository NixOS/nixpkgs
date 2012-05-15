{ stdenv, fetchurl, perl, perlXMLParser, xkbcomp, gettext, intltool  }:

stdenv.mkDerivation rec {
  name = "xkeyboard-config-2.5.1";

  src = fetchurl {
    url = "mirror://xorg/individual/data/${name}.tar.bz2";
    sha256 = "14ncsbzi8l1dw0ypd36az9kxvrsqfspl3w51zj5p52f373ffi07b";
  };

  buildInputs = [ gettext ];

  buildNativeInputs = [ perl perlXMLParser intltool xkbcomp ];

  patches = [ ./eo.patch ];

  preConfigure = ''
    configureFlags="--with-xkb-base=$out/etc/X11/xkb -with-xkb-rules-symlink=xorg,xfree86 --disable-runtime-deps"
    sed -e 's@#!\s*/bin/bash@#! /bin/sh@' -i rules/merge.sh
  '';

  postInstall = ''
    cat ${./level3-deadkeys-us-intl} >> $out/etc/X11/xkb/symbols/us
  '';
}
