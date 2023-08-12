{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libxml2
, xdg-desktop-portal
, gtk3
, gnome
, gnome-desktop
, glib
, wrapGAppsHook
, gsettings-desktop-schemas
, buildPortalsInGnome ? true
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-gtk";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "8eyWeoiJ3b/GlqGVfmkf2/uS7FnOpRNgbfxwWjclw8w=";
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
    gnome-desktop
    gnome.gnome-settings-daemon # schemas needed for settings api (mostly useless now that fonts were moved to g-d-s)
  ];

  configureFlags = if buildPortalsInGnome then [
    "--enable-wallpaper"
    "--enable-screenshot"
    "--enable-screencast"
    "--enable-background"
    "--enable-settings"
    "--enable-appchooser"
  ] else [
    # These are now enabled by default, even though we do not need them for GNOME.
    # https://github.com/flatpak/xdg-desktop-portal-gtk/issues/355
    "--disable-settings"
    "--disable-appchooser"
  ];

  meta = with lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
