{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, m4
, intltool
, libxmlxx
, keybinder
, keybinder3
, gtk2
, gtk3
, libX11
, libfm
, libwnck2
, libwnck3
, libXmu
, libXpm
, cairo
, gdk-pixbuf
, gdk-pixbuf-xlib
, menu-cache
, lxmenu-data
, wirelesstools
, curl
, supportAlsa ? false, alsa-lib
, withGtk3 ? true
}:

stdenv.mkDerivation rec {
  pname = "lxpanel";
  version = "0.10.1";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/${pname}-${version}.tar.xz";
    sha256 = "sha256-HjGPV9fja2HCOlBNA9JDDHja0ULBgERRBh8bPqVEHug=";
  };

  nativeBuildInputs = [ pkg-config gettext m4 intltool libxmlxx ];
  buildInputs = [
    (if withGtk3 then keybinder3 else keybinder)
    (if withGtk3 then gtk3 else gtk2)
    libX11
    (libfm.override { inherit withGtk3; })
    (if withGtk3 then libwnck3 else libwnck2)
    libXmu
    libXpm
    cairo
    gdk-pixbuf
    gdk-pixbuf-xlib.dev
    menu-cache
    lxmenu-data
    m4
    wirelesstools
    curl
  ] ++ lib.optional supportAlsa alsa-lib;

  postPatch = ''
    substituteInPlace src/Makefile.in \
      --replace "@PACKAGE_CFLAGS@" "@PACKAGE_CFLAGS@ -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"
    substituteInPlace plugins/Makefile.in \
      --replace "@PACKAGE_CFLAGS@" "@PACKAGE_CFLAGS@ -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"
  '';

  configureFlags = lib.optional withGtk3 "--enable-gtk3";

  meta = with lib; {
    description = "Lightweight X11 desktop panel for LXDE";
    homepage = "https://lxde.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ryneeverett ];
    platforms = platforms.linux;
  };
}
