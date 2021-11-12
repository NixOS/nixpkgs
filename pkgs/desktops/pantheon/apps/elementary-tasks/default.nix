{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
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
  version = "6.0.4";

  repoName = "tasks";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1gb51gm8qgd8yzhqb7v69p2f1fgm3qf534if4lc85jrjsb8hgmhl";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
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

  meta = with lib; {
    homepage = "https://github.com/elementary/tasks";
    description = "Synced tasks and reminders on elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.tasks";
  };
}
