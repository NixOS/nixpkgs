{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook4
, appcenter
, elementary-settings-daemon
, glib
, gnome-settings-daemon
, granite7
, gtk4
, libadwaita
, libgee
}:

stdenv.mkDerivation rec {
  pname = "elementary-onboarding";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "onboarding";
    rev = version;
    sha256 = "sha256-p9N8Pblt15+BHcvlLjdPRyquM8w7ipieTcmUHpcMd6k=";
  };

  patches = [
    # WelcomeView: Fix missing handler when a row activated
    # https://github.com/elementary/onboarding/pull/243
    (fetchpatch {
      url = "https://github.com/elementary/onboarding/commit/391fab7867885578015abbebbe678e8d4f0f331d.patch";
      hash = "sha256-NnnvPQV2GBe8A6TiW5lq3J8hb4ruCSmri5UZ2W0fBIA=";
    })
  ];

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
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Onboarding app for new users designed for elementary OS";
    homepage = "https://github.com/elementary/onboarding";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.onboarding";
  };
}
