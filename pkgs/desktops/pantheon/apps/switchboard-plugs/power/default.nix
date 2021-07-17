{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, substituteAll
, meson
, ninja
, pkg-config
, vala
, libgee
, elementary-dpms-helper
, elementary-settings-daemon
, granite
, gtk3
, glib
, dbus
, polkit
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-power";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0w92x8g7n63hbxa2knlpx2jc13ddq7mfzgmgifniiq3xk25wq673";
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
    dbus
    elementary-dpms-helper
    elementary-settings-daemon
    glib
    granite
    gtk3
    libgee
    polkit
    switchboard
  ];

  meta = with lib; {
    description = "Switchboard Power Plug";
    homepage = "https://github.com/elementary/switchboard-plug-power";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
