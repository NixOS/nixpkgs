{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config
, libxml2
, xdg-desktop-portal
, gtk3
, gnome
, glib
, wrapGAppsHook
, gsettings-desktop-schemas
, buildPortalsInGnome ? true
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-gtk";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "7w+evZLtmTmDHVVsw25bJz99xtlSCE8qTFSxez9tlZk=";
  };

  patches = [
    # Fix broken translation.
    # https://github.com/flatpak/xdg-desktop-portal-gtk/issues/353
    (fetchpatch {
      url = "https://github.com/flatpak/xdg-desktop-portal-gtk/commit/e34f49ca8365801a7fcacccb46ab1e62aec17435.patch";
      sha256 = "umMsSP0fuSQgxlHLaZlg25ln1aAL1mssWzPMIWAOUt4=";
    })
    (fetchpatch {
      url = "https://github.com/flatpak/xdg-desktop-portal-gtk/commit/19c5385b9f5fe0f8dac8ae7cc4493bb08f802de6.patch";
      sha256 = "nbmOb5er20zBOO4K2geYITafqBaNHbDpq1OOvIVD6hY=";
    })
  ];

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

  configureFlags = lib.optionals buildPortalsInGnome [
    "--enable-wallpaper"
    "--enable-screenshot"
    "--enable-screencast"
    "--enable-background"
    "--enable-settings"
    "--enable-appchooser"
  ];

  meta = with lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
