{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gtk4,
  granite7,
  libadwaita,
  libgee,
  gcr_4,
  webkitgtk_6_0,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "elementary-capnet-assist";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "capnet-assist";
    rev = version;
    sha256 = "sha256-u+JYJ5J5Cx27MrVlhh6AXAtpKGw7Kf1+MyJEEHqgod0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gcr_4
    granite7
    gtk4
    libadwaita
    libgee
    webkitgtk_6_0
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Small WebKit app that assists a user with login when a captive portal is detected";
    homepage = "https://github.com/elementary/capnet-assist";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.capnet-assist";
  };
}
