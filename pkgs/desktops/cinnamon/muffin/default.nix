{ fetchFromGitHub
, cinnamon-desktop
, glib
, file
, gnome
, gnome-doc-utils
, fetchpatch
, gobject-introspection
, gtk3
, intltool
, json-glib
, libinput
, libstartup_notification
, libXtst
, libxkbcommon
, pkg-config
, lib, stdenv
, udev
, xorg
, wrapGAppsHook
, pango
, cairo
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, docbook_xml_dtd_42
, docbook_xml_dtd_412
, autoconf
, automake
, gettext
, libtool
}:

# it's a frankensteins monster with some cinnamon sparkles added on top of it

stdenv.mkDerivation rec {
  pname = "muffin";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-zRW+hnoaKKTe4zIJpY1D0Ahc8k5zRbvYBF5Y4vZ6Rbs=";
  };

  buildInputs = [
    gtk3
    glib
    pango
    cairo
    json-glib
    cinnamon-desktop
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libxkbfile
    xorg.xkeyboardconfig

    libxkbcommon
    gnome.zenity
    libinput
    libstartup_notification
    libXtst
    udev
    gobject-introspection
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
    wrapGAppsHook
    pkg-config
    intltool

    gnome-doc-utils
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
    docbook_xml_dtd_42
    docbook_xml_dtd_412
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/muffin";
    description = "The window management library for the Cinnamon desktop (libmuffin) and its sample WM binary (muffin)";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
