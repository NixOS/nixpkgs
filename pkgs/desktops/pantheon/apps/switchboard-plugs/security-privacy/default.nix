{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  elementary-settings-daemon,
  libgee,
  gettext,
  granite7,
  gsettings-desktop-schemas,
  gala,
  gtk4,
  glib,
  polkit,
  zeitgeist,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-security-privacy";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-security-privacy";
    tag = version;
    hash = "sha256-OlLeeS0b4IMCvOMyHlIRaQl11ivn4Y2+vYdXOzIlvaw=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon # settings schema
    gala
    glib
    granite7
    gsettings-desktop-schemas
    gtk4
    libgee
    polkit
    switchboard
    zeitgeist
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Security & Privacy Plug";
    homepage = "https://github.com/elementary/settings-security-privacy";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };

}
