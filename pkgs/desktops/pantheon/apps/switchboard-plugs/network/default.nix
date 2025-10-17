{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  replaceVars,
  vala,
  libadwaita,
  libgee,
  gettext,
  granite7,
  gtk4,
  networkmanager,
  networkmanagerapplet,
  libnma-gtk4,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-network";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-network";
    rev = version;
    hash = "sha256-H43mRPEujs6A4Bk2uC3mP91Hp5I8gojaagoXUT/5eW8=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit networkmanagerapplet;
    })
  ];

  nativeBuildInputs = [
    gettext
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
    networkmanager
    libnma-gtk4
    switchboard
  ];

  strictDeps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Networking Plug";
    homepage = "https://github.com/elementary/switchboard-plug-network";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
