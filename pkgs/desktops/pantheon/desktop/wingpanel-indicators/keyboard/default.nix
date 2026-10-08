{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  replaceVars,
  vala,
  gtk3,
  granite,
  libxml2,
  wingpanel,
  libgee,
  xkeyboard-config,
  libgnomekbd,
  ibus,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-keyboard";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel-indicator-keyboard";
    rev = version;
    sha256 = "sha256-vPQ+Bt7ggeT3Zzsvbie8Wpu3D2WMEIh8GDOI3frnedM=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      gkbd_keyboard_display = "${libgnomekbd}/bin/gkbd-keyboard-display";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    libxml2
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    ibus
    libgee
    wingpanel
    xkeyboard-config
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Keyboard Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-keyboard";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
