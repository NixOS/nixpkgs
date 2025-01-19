{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  gettext,
  glib,
  granite7,
  gtk4,
  switchboard,
  elementary-notifications,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-notifications";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-53rpnp1RWdPofY00XWKiz8WDPC7RNMaGQFHBDzjsIt4=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-notifications
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Notifications Plug";
    homepage = "https://github.com/elementary/switchboard-plug-notifications";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.pantheon.members;
  };
}
