{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libadwaita
, libgee
, gnome-settings-daemon
, granite7
, gtk4
, glib
, dbus
, polkit
, switchboard
, wingpanel-indicator-power
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-power";
  version = "2.7.0-unstable-2024-05-15";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "036eeacfe8e54a21f5103240a6883580ded030d7";
    sha256 = "sha256-R3fDDuvPrq/fErsD1OMMawEUJO+am96tZU4M6iejmbI=";
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
    granite7
    gtk4
    libadwaita
    libgee
    polkit
    switchboard
    wingpanel-indicator-power # settings schema
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Power Plug";
    homepage = "https://github.com/elementary/switchboard-plug-power";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
