{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-daemon";
    rev = version;
    sha256 = "sha256-w5dRQPRsM52wqusTLLPmKmVwoBFS+pHOokfDmCDxVWM=";
  };

  patches = [
    # Fix build with fwupd 2.0.0
    # https://github.com/elementary/settings-daemon/pull/169
    (fetchpatch {
      url = "https://github.com/elementary/settings-daemon/commit/f9f9e6c49ef89451ad45aa8314769a0358a5e481.patch";
      hash = "sha256-zLONUqRwODK3JXaoymztEfOIJONJpwcTp5AWv0Vl+EI=";
    })
  ];

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
