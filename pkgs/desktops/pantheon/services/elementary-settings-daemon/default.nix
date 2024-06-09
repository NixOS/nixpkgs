{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, accountsservice
, dbus
, desktop-file-utils
, fwupd
, gdk-pixbuf
, geoclue2
, gexiv2
, glib
, gobject-introspection
, gtk3
, granite
, libgee
, packagekit
, systemd
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "elementary-settings-daemon";
  version = "1.3.1-unstable-2024-05-11";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-daemon";
    rev = "88781f2fabccdf8598c494a71782610c1ee62ca4";
    sha256 = "sha256-uesl3n30izQeF7JAbkRrgiLCHS9QGpRX3o5gcmkl4Ik=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    accountsservice
    dbus
    fwupd
    gdk-pixbuf
    geoclue2
    gexiv2
    glib
    gtk3
    granite
    libgee
    packagekit
    systemd
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Settings daemon for Pantheon";
    homepage = "https://github.com/elementary/settings-daemon";
    license = licenses.gpl3Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "io.elementary.settings-daemon";
  };
}
