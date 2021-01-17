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
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-swcbkaHHe9BZxMWvjdRutvYfXXrSCUJWuld1btfYeH0=";
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

  patches = [
    (substituteAll {
      src = ./dpms-helper-exec.patch;
      elementary_dpms_helper = elementary-dpms-helper;
    })
  ];

  meta = with lib; {
    description = "Switchboard Power Plug";
    homepage = "https://github.com/elementary/switchboard-plug-power";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
