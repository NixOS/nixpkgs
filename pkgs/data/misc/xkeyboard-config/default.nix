{stdenv, fetchurl, perl, perlXMLParser, xkbcomp, gettext, intltool}:

stdenv.mkDerivation {
  name = "xkeyboard-config-1.4";

  src = fetchurl {
    url = http://xlibs.freedesktop.org/xkbdesc/xkeyboard-config-1.4.tar.bz2;
    sha256 = "1qdhhc5ji8677dna9qj6kisgpfzhpjmaavdjzvvrv9chrxyqa6lj";
  };

  buildInputs = [perl perlXMLParser xkbcomp gettext intltool];

  ICONV = "iconv";

  preConfigure = ''
    configureFlags="--with-xkb-base=$out/etc/X11/xkb -with-xkb-rules-symlink=xorg,xfree86"
  '';

  postInstall = ''
    cat ${./level3-deadkeys-us-intl} >> $out/etc/X11/xkb/symbols/us
  '';
}
