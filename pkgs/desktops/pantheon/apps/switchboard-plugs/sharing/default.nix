{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, elementary-bluetooth-daemon
, libgee
, granite7
, gtk4
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sharing";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-0XfXxN1hI1Qak0J43lnNA/D0suqeKbYLjo+a+Peu6Us=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-bluetooth-daemon
    granite7
    gtk4
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Sharing Plug";
    homepage = "https://github.com/elementary/switchboard-plug-sharing";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
