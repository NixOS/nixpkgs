{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, switchboard
, elementary-settings-daemon
, glib
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-mouse-touchpad";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-WJ/GRhZsSwC31HEIjHHWBy9/Skqbwor0tNVTedue3kk=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libgee
    elementary-settings-daemon
    switchboard
  ];

  meta = with lib; {
    description = "Switchboard Mouse & Touchpad Plug";
    homepage = "https://github.com/elementary/switchboard-plug-mouse-touchpad";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
