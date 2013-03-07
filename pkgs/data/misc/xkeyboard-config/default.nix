{ stdenv, fetchurl, perl, perlXMLParser, xkbcomp, gettext, intltool  }:

stdenv.mkDerivation rec {
  name = "xkeyboard-config-2.7";

  src = fetchurl {
    url = "mirror://xorg/individual/data/xkeyboard-config/${name}.tar.bz2";
    sha256 = "08c3mjdgp7c2v6lj5bymaczcazklsd7s1lxslxbngzmh5yhphd74";
  };

  buildInputs = [ gettext ];

  nativeBuildInputs = [ perl perlXMLParser intltool xkbcomp ];

  patches = [ ./eo.patch ];

  preConfigure = ''
    configureFlags="--with-xkb-base=$out/etc/X11/xkb -with-xkb-rules-symlink=xorg,xfree86 --disable-runtime-deps"
    sed -e 's@#!\s*/bin/bash@#! /bin/sh@' -i rules/merge.sh
  '';

  postInstall = ''
    cat ${./level3-deadkeys-us-intl} >> $out/etc/X11/xkb/symbols/us
  '';
}
