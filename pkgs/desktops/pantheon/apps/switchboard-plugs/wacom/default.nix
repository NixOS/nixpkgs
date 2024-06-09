{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, glib
, granite7
, gtk4
, libadwaita
, libgee
, libgudev
, libwacom
, switchboard
, xorg
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-wacom";
  version = "1.0.1-unstable-2024-03-22";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "c69e306f4fe0ad72bbf445443bd89df3554dcae5";
    sha256 = "sha256-0ouy71z4oa8g6K+cHS7sRAVGvHxm+fXvWvvRit2jBps=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
    libgee
    libgudev
    libwacom
    switchboard
    xorg.libX11
    xorg.libXi
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Wacom Plug";
    homepage = "https://github.com/elementary/switchboard-plug-wacom";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
