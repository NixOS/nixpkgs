{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libxml2
, xdg-desktop-portal
, gtk3
, gnome
, glib
, wrapGAppsHook
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-gtk";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "0987fwsdgkcd3mh3scvg2kyg4ay1rr5w16js4pl3pavw9yhl9lbi";
  };

  nativeBuildInputs = [
    autoreconfHook
    libxml2
    pkg-config
    wrapGAppsHook
    xdg-desktop-portal
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas # settings exposed by settings portal
    gtk3
    gnome.gnome-desktop
    gnome.gnome-settings-daemon # schemas needed for settings api (mostly useless now that fonts were moved to g-d-s)
  ];

  meta = with lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
