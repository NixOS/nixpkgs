{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, evolution-data-server
, glib
, granite
, gtk3
, libgdata
, libhandy
, sqlite
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-onlineaccounts";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-Q/vvXKyeedn5o7HnL9F5ixSjJS3OWrvvHbzvx2fW2qY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    evolution-data-server
    glib
    granite
    gtk3
    libgdata
    libhandy
    sqlite # needed for camel-1.2
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Online Accounts Plug";
    homepage = "https://github.com/elementary/switchboard-plug-onlineaccounts";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
