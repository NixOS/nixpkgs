{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
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
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "onboarding";
    rev = version;
    sha256 = "sha256-bxOy9VivpgL4xXJhDF7K/gpq9zcCFIJFfRpG7QC8svE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
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

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
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
