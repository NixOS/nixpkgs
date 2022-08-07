{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, accountsservice
, dbus
, desktop-file-utils
, geoclue2
, glib
, gobject-introspection
, gtk3
, granite
, libgee
, systemd
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-settings-daemon";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-daemon";
    rev = version;
    sha256 = "sha256-5QdCj2Z31t7dxZi7ZZ5g6qLgsMyw7rM5dRw0G8uoC6o=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    dbus
    geoclue2
    glib
    gtk3
    granite
    libgee
    systemd
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
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
