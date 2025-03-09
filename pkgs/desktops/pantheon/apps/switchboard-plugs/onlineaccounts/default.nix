{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  evolution-data-server-gtk4,
  glib,
  granite7,
  gtk4,
  libadwaita,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-onlineaccounts";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-E4UAhrs+YQ47VEHMFY8PbSFvBqhqrTf4aPezeqEjdLo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    evolution-data-server-gtk4
    glib
    granite7
    gtk4
    libadwaita
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Online Accounts Plug";
    homepage = "https://github.com/elementary/switchboard-plug-onlineaccounts";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
