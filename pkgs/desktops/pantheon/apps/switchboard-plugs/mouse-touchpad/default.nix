{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala
, libgee
, libxml2
, granite
, gtk3
, switchboard
, elementary-settings-daemon
, glib
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-mouse-touchpad";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "19kiwrdpan8hr5r79y591591qjx7pm3x814xfkg9vi11ndbcrznr";
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
    libxml2
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
