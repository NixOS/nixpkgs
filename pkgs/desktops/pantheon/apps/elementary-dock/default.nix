{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook4
, glib
, granite7
, gtk4
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "elementary-dock";
  version = "0-unstable-2024-05-15";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "dock";
    rev = "1c324c00faad8e29e72e6ff5fc0250ab9b9dc6f9";
    sha256 = "sha256-WXHkoRZtOKohRzQplomz/lx+fX56MF4kRQE7bOd7ljo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "Elegant, simple, clean dock";
    homepage = "https://github.com/elementary/dock";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ] ++ teams.pantheon.members;
    mainProgram = "io.elementary.dock";
  };
}
