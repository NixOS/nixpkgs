{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vala
, wayland-scanner
, wrapGAppsHook4
, glib
, granite7
, gtk4
, libadwaita
, wayland
}:

stdenv.mkDerivation rec {
  pname = "elementary-dock";
  version = "0-unstable-2024-07-13";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "dock";
    rev = "db6d118de5ec95c4981f380f0bc35fd496ef88ec";
    sha256 = "sha256-MpBQbluddyrgonVnNfzJuQr6QnoNAjtThDaAp64N5ko=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
    wayland
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
