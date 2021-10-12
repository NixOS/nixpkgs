{ lib, stdenv
, fetchFromGitHub
, substituteAll
, nix-update-script
, pantheon
, gnome
, pkg-config
, meson
, python3
, ninja
, vala
, gtk3
, granite
, bamf
, libgtop
, libnotify
, udev
, wingpanel
, libgee
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-power";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1zlpnl7983jkpy2nik08ih8lwrqvm456h993ixa6armzlazdvnjk";
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
    python3
    vala
  ];

  buildInputs = [
    bamf
    granite
    gtk3
    libgee
    libgtop
    libnotify
    udev
    wingpanel
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      gnome_power_manager = gnome.gnome-power-manager;
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Power Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-power";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
