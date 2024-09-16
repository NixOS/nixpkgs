{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, glib
, libadwaita
, libgee
, granite7
, gexiv2
, gnome-settings-daemon
, elementary-settings-daemon
, gtk4
, gala
, wingpanel
, wingpanel-indicator-keyboard
, wingpanel-quick-settings
, switchboard
, gettext
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-pantheon-shell";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-Cv1Ldvk0+VzNsKnDFwDtLZ5ixUOGV+PWYAqN9KV9g/s=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon
    gnome-settings-daemon
    gala
    gexiv2
    glib
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
    wingpanel
    wingpanel-indicator-keyboard # gsettings schemas
    wingpanel-quick-settings # gsettings schemas
  ];

  postPatch = ''
    # Hide these before we land the new dock
    substituteInPlace src/Views/Dock.vala \
      --replace-fail "box.append (icon_box);" "" \
      --replace-fail "box.append (hide_box);" ""
  '';

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
