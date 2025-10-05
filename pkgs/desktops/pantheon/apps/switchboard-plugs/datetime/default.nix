{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  replaceVars,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  libical,
  granite7,
  gettext,
  gtk4,
  libxml2,
  switchboard,
  tzdata,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-datetime";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-datetime";
    rev = version;
    sha256 = "sha256-VOL0F0obuXVz0G5hMI/hpUf2T3H8XUw64wu4MxRi57g=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      tzdata = tzdata;
    })
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libgee
    libical
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Date & Time Plug";
    homepage = "https://github.com/elementary/switchboard-plug-datetime";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
