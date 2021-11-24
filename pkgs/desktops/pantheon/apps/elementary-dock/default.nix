{ lib
, stdenv
, fetchFromGitHub
, vala
, atk
, cairo
, dconf
, glib
, gtk3
, libwnck
, libX11
, libXfixes
, libXi
, pango
, gettext
, pkg-config
, libxml2
, bamf
, gdk-pixbuf
, libdbusmenu-gtk3
, gnome-menus
, libgee
, wrapGAppsHook
, pantheon
, meson
, ninja
, granite
}:

stdenv.mkDerivation rec {
  pname = "elementary-dock";
  version = "unstable-2021-11-08";

  outputs = [ "out" "dev" ];

  repoName = "dock";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "51e8d3ddfbed0dfce3158d80f997ab183e92567b";
    sha256 = "sha256-w6HGxEAXNod/uMEEfSz9nRNTRrCbcEqJCP9EFkVbX1U=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    libxml2 # xmllint
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    bamf
    cairo
    gdk-pixbuf
    glib
    gnome-menus
    dconf
    granite
    gtk3
    libX11
    libXfixes
    libXi
    libdbusmenu-gtk3
    libgee
    libwnck
    pango
  ];

  meta = with lib; {
    description = "Elegant, simple, clean dock";
    homepage = "https://github.com/elementary/dock";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ] ++ teams.pantheon.members;
    mainProgram = "plank";
  };
}
