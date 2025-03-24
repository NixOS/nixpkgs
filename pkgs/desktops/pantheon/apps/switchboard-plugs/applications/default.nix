{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  gettext,
  meson,
  ninja,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  granite7,
  gtk4,
  switchboard,
  flatpak,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-applications";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-jdSdzOHu1u/8N/eN6D9MjR/9K7n+rfmuBpyRSweb6lA=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    flatpak
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Applications Plug";
    homepage = "https://github.com/elementary/switchboard-plug-applications";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
