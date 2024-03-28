{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, glib
, gnome-online-accounts
, gtk4
, libadwaita
}:

stdenv.mkDerivation {
  pname = "gnome-online-accounts-gtk";
  version = "0-unstable-2024-03-23";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "gnome-online-accounts-gtk";
    rev = "c774d6cb00114f234fbd2a6d4795288ac5c00260";
    hash = "sha256-EO0H4yRVJ5kmw+uGfnxRXHTxQFC9vYokqfTgazKHI0c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gnome-online-accounts
    gtk4
    libadwaita # for goa-backend
  ];

  meta = with lib; {
    description = "Online accounts configuration utility";
    homepage = "https://github.com/linuxmint/gnome-online-accounts-gtk";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
