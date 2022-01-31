{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, appstream
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, clutter-gtk
, elementary-icon-theme
, evolution-data-server
, granite
, geoclue2
, geocode-glib
, gtk3
, libchamplain
, libgdata
, libgee
, libhandy
, libical
}:

stdenv.mkDerivation rec {
  pname = "elementary-tasks";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "tasks";
    rev = version;
    sha256 = "sha256-eHaWXntLkk5G+cR5uFwWsIvbSPsbrvpglYBh91ta/M0=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gtk
    elementary-icon-theme
    evolution-data-server
    granite
    geoclue2
    geocode-glib
    gtk3
    libchamplain
    libgdata
    libgee
    libhandy
    libical
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
    homepage = "https://github.com/elementary/tasks";
    description = "Synced tasks and reminders on elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.tasks";
  };
}
