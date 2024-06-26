{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  python3,
  vala,
  wrapGAppsHook3,
  clutter,
  evolution-data-server,
  folks,
  geoclue2,
  geocode-glib_2,
  granite,
  gtk3,
  libchamplain_libsoup3,
  libgee,
  libhandy,
  libical,
  libportal-gtk3,
}:

stdenv.mkDerivation rec {
  pname = "elementary-calendar";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calendar";
    rev = version;
    sha256 = "sha256-qZvSzhLGr4Gg9DSJ638IQRLlPiZkbJUCJ7tZ8ZFZZ1E=";
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
    clutter
    evolution-data-server
    folks
    geoclue2
    geocode-glib_2
    granite
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
    description = "Desktop calendar app designed for elementary OS";
    homepage = "https://github.com/elementary/calendar";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.calendar";
  };
}
