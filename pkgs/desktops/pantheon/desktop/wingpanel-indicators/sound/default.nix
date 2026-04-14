{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gnome-settings-daemon,
  gtk3,
  granite,
  wingpanel,
  libnotify,
  pulseaudio,
  libcanberra-gtk3,
  libgee,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-sound";
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel-indicator-sound";
    tag = version;
    hash = "sha256-3naN6qVsAjImFDU4DPR5c/leT8ecGUbbOppmSox4QTk=";
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gnome-settings-daemon # media-keys
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libnotify
    pulseaudio
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Sound Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-sound";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
