{ stdenv, fetchurl, pkgconfig, gettext, m4, intltool, libxmlxx, keybinder
, gtk2, libX11, libfm, libwnck, libXmu, libXpm, cairo, gdk-pixbuf, gdk-pixbuf-xlib
, menu-cache, lxmenu-data, wirelesstools
, supportAlsa ? false, alsaLib
}:

stdenv.mkDerivation rec {
  name = "lxpanel-0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${name}.tar.xz";
    sha256 = "1ccgv7jgl3y865cpb6w7baaz7468fxncm83bqxlwyni5bwhglb1l";
  };

  nativeBuildInputs = [ pkgconfig gettext m4 intltool libxmlxx ];
  buildInputs = [
    keybinder gtk2 libX11 libfm libwnck libXmu libXpm cairo gdk-pixbuf gdk-pixbuf-xlib.dev
    menu-cache lxmenu-data m4 wirelesstools
  ] ++ stdenv.lib.optional supportAlsa alsaLib;

  postPatch = ''
    substituteInPlace src/Makefile.in \
      --replace "@PACKAGE_CFLAGS@" "@PACKAGE_CFLAGS@ -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"
    substituteInPlace plugins/Makefile.in \
      --replace "@PACKAGE_CFLAGS@" "@PACKAGE_CFLAGS@ -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"
  '';

  meta = {
    description = "Lightweight X11 desktop panel for LXDE";
    homepage = "https://lxde.org/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.ryneeverett ];
    platforms = stdenv.lib.platforms.linux;
  };
}
