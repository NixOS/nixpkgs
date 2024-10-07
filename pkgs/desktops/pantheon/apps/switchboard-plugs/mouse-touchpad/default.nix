{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, substituteAll
, meson
, ninja
, pkg-config
, vala
, libgee
, libxml2
, granite7
, gtk4
, switchboard
, gnome-settings-daemon
, glib
, gala # needed for gestures support
, touchegg
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-mouse-touchpad";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-aOJnjHCyc1tSyF7AuW5nXUXcvzBnZ+pwU91Mk+veusg=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      touchegg = touchegg;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gala
    glib
    granite7
    gtk4
    libgee
    libxml2
    gnome-settings-daemon
    switchboard
    touchegg
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Mouse & Touchpad Plug";
    homepage = "https://github.com/elementary/switchboard-plug-mouse-touchpad";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
