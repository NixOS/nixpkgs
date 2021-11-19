{ lib, stdenv
, fetchFromGitHub
, meson
, ninja
, pantheon
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
  version = "1.1.0";

  repoName = "settings-daemon";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-1Xp1uJzDFuGZlhJhKj00cYtb4Q1syMAm+82fTOtk0VI=";
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

  meta = with lib; {
    description = "Settings daemon for Pantheon";
    homepage = "https://github.com/elementary/settings-daemon";
    license = licenses.gpl3Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "io.elementary.settings-daemon";
  };
}
