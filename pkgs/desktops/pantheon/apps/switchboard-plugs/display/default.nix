{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libgee
, libhandy
, granite
, gtk3
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-display";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-3sYZCazGnTjIi3Iry5673TMI13sD0GuY+46AK+NJH70=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    libhandy
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Displays Plug";
    homepage = "https://github.com/elementary/switchboard-plug-display";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
