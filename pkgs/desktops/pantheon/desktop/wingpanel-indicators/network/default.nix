{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, substituteAll
, pkg-config
, meson
, ninja
, vala
, gtk3
, granite
, networkmanager
, libnma
, wingpanel
, libgee
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-network";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-j6USKTpiktDKH7jBV1FFg8f3HeNwEkMp3HxG/MeL41g=";
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
    networkmanager
    libnma
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Network Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-network";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
