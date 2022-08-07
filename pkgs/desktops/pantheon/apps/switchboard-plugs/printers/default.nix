{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, cups
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-printers";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-NY52surcvhUtyP+T4RMZ0cd+H7fSwo1V0qEGY//oXGs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    cups
    granite
    gtk3
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Printers Plug";
    homepage = "https://github.com/elementary/switchboard-plug-printers";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
