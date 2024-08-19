{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook4
, appcenter
, elementary-settings-daemon
, glib
, granite7
, gtk4
, libadwaita
, libgee
}:

stdenv.mkDerivation rec {
  pname = "elementary-onboarding";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "onboarding";
    rev = version;
    sha256 = "sha256-oG6L2t99BWeu8C6kE6IKgyc57Q8D1O9fdEMLnRA6AWY=";
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
