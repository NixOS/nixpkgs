args: with args;

stdenv.mkDerivation {
  name = "xkeyboard-config-${version}";

  src = fetchurl {
          url = http://xlibs.freedesktop.org/xkbdesc/xkeyboard-config-1.2.tar.bz2;
          sha256 = "1xr7vfgabgyggnkjb56a0bd39yxjhyrldcdsq9pqnw3izfb6i1b4";
        };
  buildInputs = [perl perlXMLParser xkbcomp gettext];

  ICONV = "iconv";

  preConfigure = "
    configureFlags=\"--with-xkb-base=$out/etc/X11/xkb -with-xkb-rules-symlink=xorg,xfree86\"
  ";

  patches = [ ./eo.patch ];

  postInstall = ''
  	rm ''${out}/etc/X11/xkb/compiled || true;
	cat ${./level3-deadkeys-us-intl} | sed -e 's/altgr-intl/altgr-intl-rich/g' >> $out/etc/X11/xkb/symbols/us
  '';
}
