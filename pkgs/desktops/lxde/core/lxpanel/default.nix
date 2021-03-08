{ lib, stdenv, fetchurl, pkg-config, gettext, m4, intltool, libxmlxx, keybinder
, gtk2, libX11, libfm, libwnck, libXmu, libXpm, cairo, gdk-pixbuf, gdk-pixbuf-xlib
, menu-cache, lxmenu-data, wirelesstools, curl
, supportAlsa ? false, alsaLib
}:

stdenv.mkDerivation rec {
  name = "lxpanel-0.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${name}.tar.xz";
    sha256 = "0zis3b815p375s6mymhf5sn1a0c1xv0ixxzb0mh3fqhrby6cqy26";
  };

  nativeBuildInputs = [ pkg-config gettext m4 intltool libxmlxx ];
  buildInputs = [
    keybinder gtk2 libX11 libfm libwnck libXmu libXpm cairo gdk-pixbuf gdk-pixbuf-xlib.dev
    menu-cache lxmenu-data m4 wirelesstools curl
  ] ++ lib.optional supportAlsa alsaLib;

  postPatch = ''
    substituteInPlace src/Makefile.in \
      --replace "@PACKAGE_CFLAGS@" "@PACKAGE_CFLAGS@ -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"
    substituteInPlace plugins/Makefile.in \
      --replace "@PACKAGE_CFLAGS@" "@PACKAGE_CFLAGS@ -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"
  '';

  meta = {
    description = "Lightweight X11 desktop panel for LXDE";
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.ryneeverett ];
    platforms = lib.platforms.linux;
  };
}
