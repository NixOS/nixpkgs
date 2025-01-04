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
  granite7,
  gtk4,
  packagekit,
  polkit,
  switchboard,
  udisks2,
  fwupd,
  appstream,
  elementary-settings-daemon,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-Z+dhNUGDDLxzPLAaFkvWA+d6YvfM5NayOMu3SKjswLs=";
  };

  nativeBuildInputs = [
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
    udisks2
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard About Plug";
    homepage = "https://github.com/elementary/switchboard-plug-about";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
