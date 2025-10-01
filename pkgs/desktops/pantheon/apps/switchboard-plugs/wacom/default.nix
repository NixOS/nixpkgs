{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  glib,
  granite7,
  gtk4,
  libadwaita,
  libgee,
  libgudev,
  libwacom,
  switchboard,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-wacom";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-wacom";
    rev = version;
    sha256 = "sha256-xTv3QPlLPJQ6C5t4Udy1H9IrLQGuik8prvGlpfFm1DQ=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
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
    teams = [ teams.pantheon ];
  };
}
