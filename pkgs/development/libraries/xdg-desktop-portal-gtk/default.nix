{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, libxml2
, xdg-desktop-portal
, gtk3
, gnome3
, glib
, wrapGAppsHook
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-gtk";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "183iha9dxmvprn99ymgz17jx1lyn1fj5jyj6ghxl716zn9mxmird";
  };

  nativeBuildInputs = [
    autoreconfHook
    libxml2
    pkgconfig
    wrapGAppsHook
    xdg-desktop-portal
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk3
    gnome3.gnome-desktop
    gnome3.gnome-settings-daemon # schemas needed for settings api (fonts, etc)
  ];

  meta = with stdenv.lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
