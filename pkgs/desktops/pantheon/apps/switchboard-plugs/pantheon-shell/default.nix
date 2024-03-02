{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, glib
, libgee
, libhandy
, granite
, gexiv2
, gnome-settings-daemon
, elementary-settings-daemon
, gtk3
, gnome-desktop
, gala
, wingpanel
, elementary-dock
, switchboard
, gettext
, bamf
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-pantheon-shell";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-iq1QXC6eQ2w5j9RCxhTc0dApMfiDGcVuj8nocEFLFNk=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    bamf
    elementary-dock
    elementary-settings-daemon
    gnome-settings-daemon
    gala
    gexiv2
    glib
    gnome-desktop
    granite
    gtk3
    libgee
    libhandy
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
