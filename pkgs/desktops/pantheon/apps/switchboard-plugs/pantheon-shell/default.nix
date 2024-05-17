{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, glib
, libadwaita
, libgee
, granite7
, gexiv2
, gnome-settings-daemon
, elementary-settings-daemon
, gtk4
, gala
, wingpanel
, switchboard
, gettext
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-pantheon-shell";
  version = "6.5.0-unstable-2024-05-09";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "ed9e8f6a341fdc07546bd7f129cad242d78135d5";
    sha256 = "sha256-mCOrkobKwf85997WUgi3B1MyFEgdA4oeReFx+HfmbO4=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon
    gnome-settings-daemon
    gala
    gexiv2
    glib
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Desktop Plug";
    homepage = "https://github.com/elementary/switchboard-plug-pantheon-shell";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
