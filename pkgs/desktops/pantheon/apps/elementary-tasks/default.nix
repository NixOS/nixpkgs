{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, clutter-gtk
, evolution-data-server
, granite
, geoclue2
, geocode-glib_2
, gtk3
, libchamplain_libsoup3
, libgee
, libhandy
, libical
}:

stdenv.mkDerivation rec {
  pname = "elementary-tasks";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "tasks";
    rev = version;
    sha256 = "sha256-b8KUlfpZxRFDiBjgrV/4XicCcEw2fWaN78NaOq6jQBk=";
  };

  patches = [
    # Port to libsoup 3
    # https://github.com/elementary/tasks/pull/345
    (fetchpatch {
      url = "https://github.com/elementary/tasks/commit/22e0d18693932e9eea3d2a22329f845575ce26e6.patch";
      sha256 = "sha256-nLJlKf4L7G12ZnCo4wezyMRyeAf+Tf0OGHyT8I1ZuDA=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
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
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
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
