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
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-eCWse/rEuAG5YSW+/EOB/aAvikyof0KwbVtLthCGqRQ=";
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
