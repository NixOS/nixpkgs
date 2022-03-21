{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libgee
, gnome-settings-daemon
, granite
, gtk3
, glib
, dbus
, polkit
, switchboard
, wingpanel-indicator-power
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-power";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "006h8mrhmdrbd83vhdyahgrfk9wh6j9kjincpp7dz7sl8fsyhmcr";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    dbus
    gnome-settings-daemon
    glib
    granite
    gtk3
    libgee
    polkit
    switchboard
    wingpanel-indicator-power # settings schema
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Power Plug";
    homepage = "https://github.com/elementary/switchboard-plug-power";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
