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
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel-indicator-sound";
    rev = version;
    sha256 = "sha256-oWgq8rgdK81QsN/LhVUk6YgKYG4pFjVfu00t974n+i8=";
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
