{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, elementary-settings-daemon
, libgee
, granite7
, gsettings-desktop-schemas
, gala
, gtk4
, glib
, polkit
, zeitgeist
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-security-privacy";
  version = "7.1.0-unstable-2024-05-04";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "3751b775ff7866552c75f028b40289fce9b9047e";
    sha256 = "sha256-1CBzaHnDmPFkTo0G2dKM+Sy9myNEA4eYvVx6MIk7cOY=";
  };

  nativeBuildInputs = [
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
    homepage = "https://github.com/elementary/switchboard-plug-security-privacy";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
