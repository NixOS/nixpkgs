{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  appcenter,
  elementary-settings-daemon,
  glib,
  gnome-settings-daemon,
  granite7,
  gtk4,
  libadwaita,
  libgee,
  pantheon-wayland,
}:

stdenv.mkDerivation rec {
  pname = "elementary-onboarding";
  version = "8.0.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "onboarding";
    rev = version;
    sha256 = "sha256-d/8kVAvEUKNlpXRsKQrA0LCJetut2MlQlLq7MgIKlhk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    appcenter # settings schema
    elementary-settings-daemon # settings schema
    glib
    gnome-settings-daemon # org.gnome.settings-daemon.plugins.color
    granite7
    gtk4
    libadwaita
    libgee
    pantheon-wayland
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Onboarding app for new users designed for elementary OS";
    homepage = "https://github.com/elementary/onboarding";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "io.elementary.onboarding";
  };
}
