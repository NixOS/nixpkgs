{ fetchFromGitHub
, cinnamon-desktop
, glib
, file
, gnome3
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
, pkgconfig
, stdenv
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
  version = "4.6.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "1p8irzf20wari1id5rfx5sypywih1jsrmn0f83zlyhc5fxg02r5p";
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
    gnome3.zenity
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
    pkgconfig
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/muffin";
    description = "The window management library for the Cinnamon desktop (libmuffin) and its sample WM binary (muffin)";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
