{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook3
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
, libportal-gtk3
}:

stdenv.mkDerivation rec {
  pname = "elementary-tasks";
  version = "6.3.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "tasks";
    rev = version;
    sha256 = "sha256-6Vwx+NRVGDqZzN5IVk4cQxGjSkYwrrNhUVoB8TRo28U=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
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
