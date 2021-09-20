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
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-settings-daemon";
  version = "1.0.0";

  repoName = "settings-daemon";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1masvy1f9z2cp8w5ajnhy4k9bzvzgfziqlm59bf146pdd2567hiw";
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
  };
}
