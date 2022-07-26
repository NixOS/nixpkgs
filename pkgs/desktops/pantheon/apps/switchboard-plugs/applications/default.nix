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
, switchboard
, flatpak
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-applications";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "18izmzhqp6x5ivha9yl8gyz9adyrsylw7w5p0cwm1bndgqbi7yh5";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    flatpak
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
    description = "Switchboard Applications Plug";
    homepage = "https://github.com/elementary/switchboard-plug-applications";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
