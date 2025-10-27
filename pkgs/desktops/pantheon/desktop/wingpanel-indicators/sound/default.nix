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
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel-indicator-sound";
    tag = version;
    hash = "sha256-a2yl6HKNLo3660OPEp/9AtwpPerLGYD/k8fl+R5ct/g=";
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

  meta = with lib; {
    description = "Sound Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-sound";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
