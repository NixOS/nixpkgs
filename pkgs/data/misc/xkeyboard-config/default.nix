{stdenv, fetchurl, perl, perlXMLParser, xkbcomp}:

stdenv.mkDerivation {
  name = "xkeyboard-config-0.9";

  src = fetchurl {
    url = http://xlibs.freedesktop.org/xkbdesc/xkeyboard-config-0.9.tar.bz2;
    sha256 = "0zbpprhlv8ggsvgnwqw8d4cx0ry86szm36ghigwb1sn46q0c915v";
  };

  buildInputs = [perl perlXMLParser xkbcomp];

  ICONV = "iconv";

  preConfigure = "
    configureFlags=\"--with-xkb-base=$out/etc/X11/xkb -with-xkb-rules-symlink=xorg,xfree86\"
  ";
}
