{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libxml2, xdg-desktop-portal, gtk3, glib, wrapGAppsHook, gnome3 }:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-gtk";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "1vgnsahljzrjcdjzv1dxhp2rf709pnf8595an82llnylwa8rdp1j";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libxml2 xdg-desktop-portal wrapGAppsHook ];
  buildInputs = [ glib gtk3 gnome3.gsettings-desktop-schemas ];

  meta = with stdenv.lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
