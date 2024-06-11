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
  version = "0-unstable-2024-06-11";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "dock";
    rev = "ba5dfdfd5d8217379ede3db6fe29eca193a21a51";
    sha256 = "sha256-x5dRmUp6TdWNSlORgGPV2bIOjU2vosq7qkUQjlfTN6Q=";
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
