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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "1gpbjkfkrpk96krc1zbccrq7sih282mg303ifxaaxbnj6d8drm5h";
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
  ];

  meta = with stdenv.lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
