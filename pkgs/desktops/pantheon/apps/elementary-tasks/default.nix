{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook3,
  clutter-gtk,
  evolution-data-server,
  granite,
  geoclue2,
  geocode-glib_2,
  gtk3,
  libchamplain_libsoup3,
  libgee,
  libhandy,
  libical,
  libportal-gtk3,
}:

stdenv.mkDerivation rec {
  pname = "elementary-tasks";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "tasks";
    rev = version;
    hash = "sha256-xOMS4Zwfl7TLHvm8Zn6wQ4ZoMg+Yuci+cTpUVG+liss=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    clutter-gtk
    evolution-data-server
    granite
    geoclue2
    geocode-glib_2
    gtk3
    libchamplain_libsoup3
    libgee
    libhandy
    libical
    libportal-gtk3
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/elementary/tasks";
    description = "Synced tasks and reminders on elementary OS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
=======
  meta = with lib; {
    homepage = "https://github.com/elementary/tasks";
    description = "Synced tasks and reminders on elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "io.elementary.tasks";
  };
}
