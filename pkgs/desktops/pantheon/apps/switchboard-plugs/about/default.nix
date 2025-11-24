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
  libgtop,
  libgudev,
  libsoup_3,
  gettext,
  glib,
  granite7,
  gtk4,
  packagekit,
  polkit,
  switchboard,
  udisks,
  fwupd,
  appstream,
  elementary-settings-daemon,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "8.2.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-system";
    tag = version;
    hash = "sha256-SPFCBsk4tVR+5Q6uuDG/fTIn+4TXdeAobfQxkmxMiW0=";
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
    appstream
    elementary-settings-daemon # for gsettings schemas
    fwupd
    granite7
    gtk4
    libadwaita
    libgee
    libgtop
    libgudev
    libsoup_3
    packagekit
    polkit
    switchboard
    udisks
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard About Plug";
    homepage = "https://github.com/elementary/settings-system";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };

}
