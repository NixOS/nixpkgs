{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  xdg-desktop-portal,
  gtk3,
  gnome-settings-daemon,
  gnome-desktop,
  glib,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-gtk";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal-gtk";
    rev = finalAttrs.version;
    sha256 = "sha256-uXVjKsqoIjqJilJq8ERRzEqGKbkzc+Zl6y+37CAcYro=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    xdg-desktop-portal
    gsettings-desktop-schemas # settings exposed by settings portal
    gnome-desktop
    gnome-settings-daemon # schemas needed for settings api (mostly useless now that fonts were moved to g-d-s, just mouse and xsettings)
  ];

  meta = with lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
})
