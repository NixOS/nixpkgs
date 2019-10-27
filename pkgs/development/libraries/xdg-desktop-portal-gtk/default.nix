{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, libxml2
, xdg-desktop-portal
, gtk3
, glib
, wrapGAppsHook
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-gtk";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "1zryfg6232vz1pmv0zqcxvl4clnbb15kjf55b24cimkcnidklbap";
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
  ];

  meta = with stdenv.lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
