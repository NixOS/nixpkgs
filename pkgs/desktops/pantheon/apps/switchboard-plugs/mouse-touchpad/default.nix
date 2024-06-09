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
  version = "7.0.0-unstable-2024-04-26";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "80c79bbb2fad6620f86619ccdb3779e5bcb14a7c";
    sha256 = "sha256-ldrDp8m9VKGypzATGpR+m0jXyWRgH4kjRgvd5kU3I9U=";
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
