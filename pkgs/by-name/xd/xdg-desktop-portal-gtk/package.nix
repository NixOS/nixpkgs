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
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-gtk";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal-gtk";
    rev = finalAttrs.version;
    sha256 = "sha256-aeSm6Wd0EMaZb7tYpnKT/QBt9l/fVyQLgvn5aBqQOAc=";
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
    # schemas needed for settings api (mostly useless now that fonts were moved to g-d-s, just mouse and xsettings)
    (runCommand "gnome-settings-daemon-${gnome-settings-daemon.version}-gsettings-schemas" { } ''
      mkdir -p $out/share
      cp -r ${gnome-settings-daemon}/share/gsettings-schemas/ $out/share/
    '')
  ];

  meta = with lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
})
