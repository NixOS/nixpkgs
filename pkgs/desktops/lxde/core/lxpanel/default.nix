{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, cairo
, curl
, gdk-pixbuf
, gdk-pixbuf-xlib
, gettext
, gtk3
, intltool
, keybinder3
, libX11
, libXmu
, libXpm
, libfm
, libwnck
, libxmlxx
, lxmenu-data
, menu-cache
, pkg-config
, wirelesstools
, supportAlsa ? false, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "lxpanel";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxpanel";
    rev = version;
    hash = "sha256-YUoDFO+Ip6uWjXMP+PTJqcfiGPAE4EfjQz8F4M0FxZM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    intltool
    libxmlxx
    pkg-config
  ];

  buildInputs = [
    cairo
    curl
    gdk-pixbuf
    gdk-pixbuf-xlib.dev
    gtk3
    keybinder3
    libX11
    libXmu
    libXpm
    libfm
    libwnck
    lxmenu-data
    menu-cache
    wirelesstools
  ] ++ lib.optional supportAlsa alsa-lib;

  configureFlags = [
    "--enable-gtk3"
  ];

  meta = with lib; {
    description = "Lightweight X11 desktop panel for LXDE";
    homepage = "https://lxde.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ryneeverett ];
    platforms = platforms.linux;
  };
}
